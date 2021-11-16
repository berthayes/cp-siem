#!/bin/bash

HEADER="Content-Type: application/json"
DATA=$( cat << EOF
{
	"name": "syslog",
	"config": {
		"tasks.max": "1",
		"connector.class": "io.confluent.connect.syslog.SyslogSourceConnector",
		"syslog.port": "5140",
		"syslog.listener": "UDP",
		"confluent.topic.bootstrap.servers": "broker:29092",
		"confluent.topic.replication.factor": "1"
	}
}
EOF
)

curl -X POST -H "${HEADER}" --data "${DATA}" http://localhost:8083/connectors
