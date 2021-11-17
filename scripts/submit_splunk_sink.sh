#!/bin/bash


echo "Starting the Splunk Sink connector - HEC Formatted"

HEADER="Content-Type: application/json"
DATA=$( cat << EOF
{
  "name": "SPLUNKSINK_HEC",
  "config": {
    "confluent.topic.bootstrap.servers": "broker:29092",
    "name": "SPLUNKSINK_HEC",
    "connector.class": "com.splunk.kafka.connect.SplunkSinkConnector",
    "tasks.max": "1",
    "key.converter": "org.apache.kafka.connect.storage.StringConverter",
    "value.converter": "org.apache.kafka.connect.storage.StringConverter",
    "topics": "CISCO_ASA_FILTER_106023",
    "splunk.hec.token": "3bca5f4c-1eff-4eee-9113-ea94c284478a",
    "splunk.hec.uri": "https://splunk:8090",
    "splunk.hec.ssl.validate.certs": "false",
    "splunk.hec.json.event.formatted": "true"
  }
}
EOF
)

curl -X POST -H "${HEADER}" --data "${DATA}" http://localhost:8083/connectors

echo "Starting the Splunk Sink connector - Raw"

HEADER="Content-Type: application/json"
DATA=$( cat << EOF
{
  "name": "SPLUNKSINK_RAW",
  "config": {
    "confluent.topic.bootstrap.servers": "broker:29092",
    "name": "SPLUNKSINK_RAW",
    "connector.class": "com.splunk.kafka.connect.SplunkSinkConnector",
    "tasks.max": "1",
    "key.converter": "org.apache.kafka.connect.storage.StringConverter",
    "value.converter": "org.apache.kafka.connect.storage.StringConverter",
    "topics": "AGGREGATOR",
    "splunk.hec.token": "3bca5f4c-1eff-4eee-9113-ea94c284478b",
    "splunk.hec.uri": "https://splunk:8090",
    "splunk.hec.ssl.validate.certs": "false",
    "splunk.hec.json.event.formatted": "false"
  }
}
EOF
)

curl -X POST -H "${HEADER}" --data "${DATA}" http://localhost:8083/connectors
