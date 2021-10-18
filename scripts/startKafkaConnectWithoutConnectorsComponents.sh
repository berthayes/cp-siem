#!/bin/bash
echo "Installing connector plugins"
confluent-hub install --no-prompt confluentinc/kafka-connect-elasticsearch:latest
confluent-hub install --no-prompt splunk/kafka-connect-splunk:latest
confluent-hub install --no-prompt confluentinc/kafka-connect-splunk-s2s:latest
confluent-hub install --no-prompt jcustenborder/kafka-connect-spooldir:latest
confluent-hub install --no-prompt confluentinc/kafka-connect-syslog:latest
#
echo "Launching Kafka Connect worker"
/etc/confluent/docker/run &
#
echo "waiting 2 minutes for things to stabilise"
sleep 120

echo "Starting the Spooldir connector for urlhaus csv data"

HEADER="Content-Type: application/json"
DATA=$(
  cat <<EOF
{
	"name": "csv_spooldir",
	"config": {
	  "name": "csv_spooldir",
		"connector.class": "com.github.jcustenborder.kafka.connect.spooldir.SpoolDirCsvSourceConnector",
		"tasks.max": "1",
		"topic": "urlhaus",
		"input.path": "/var/spooldir/urlhaus/csv_input",
		"finished.path": "/var/spooldir/urlhaus/csv_finished",
		"error.path": "/var/spooldir/urlhaus/csv_errors",
	  "input.file.pattern": ".*\\.csv$",
    "schema.generation.enabled": true,
    "csv.first.row.as.header": true
	}
}
EOF
)

curl -X POST -H "${HEADER}" --data "${DATA}" http://localhost:8083/connectors


echo "Sleeping forever"
sleep infinity
