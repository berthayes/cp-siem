#!/bin/bash

HEADER="Content-Type: application/json"

# if we have /var/spooldir then we know we are running from a container
if [ -d /var/spooldir/ ]
then
    if [ ! -e /var/spooldir/ad_hosts/csv_input/ad_servers.csv ]
    then
	cp /var/spooldir/ad_hosts/csv_finished/ad_servers.csv /var/spooldir/ad_hosts/csv_input/ad_servers.csv
    fi
    curl -X POST -H "${HEADER}" -d "@/tmp/scripts/adhosts_spooldir.json" http://localhost:8083/connectors
elif [ ! -e spooldir/ad_hosts/csv_input/ad_servers.csv ]
then
    cp spooldir/ad_hosts/csv_finished/ad_servers.csv spooldir/ad_hosts/csv_input/ad_servers.csv
    curl -X POST -H "${HEADER}" -d "@scripts/adhosts_spooldir.json" http://localhost:8083/connectors
fi
    

