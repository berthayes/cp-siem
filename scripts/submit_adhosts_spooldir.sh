#!/bin/bash

HEADER="Content-Type: application/json"

if [ ! -e spooldir/ad_hosts/csv_input/ad_servers.csv ]
then
    cp spooldir/ad_hosts/csv_finished/ad_servers.csv spooldir/ad_hosts/csv_input/ad_servers.csv
fi
    
curl -X POST -H "${HEADER}" -d "@scripts/adhosts_spooldir.json" http://localhost:8083/connectors
