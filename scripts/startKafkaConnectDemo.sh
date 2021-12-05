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
/tmp/scripts/submit_adhosts_spooldir.sh

echo "Sleeping forever"
sleep infinity
