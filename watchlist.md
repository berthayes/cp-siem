## Matching hostnames in a watchlist

A sample csv file of known Ad servers is in the `ad_hosts.csv` file included in this repository.

```
./cp-zeek/spooldir/ad_hosts/csv_input/ad_hosts.csv
```
It looks like this:
```
id,dateadded,domain,source
1,1602886038,fr.a2dfp.net,https://winhelp2002.mvps.org/hosts.txt
2,1602886038,mfr.a2dfp.net,https://winhelp2002.mvps.org/hosts.txt
3,1602886038,ad.a8.net,https://winhelp2002.mvps.org/hosts.txt
4,1602886038,asy.a8ww.net,https://winhelp2002.mvps.org/hosts.txt
5,1602886038,static.a-ads.com,https://winhelp2002.mvps.org/hosts.txt
6,1602886038,abcstats.com,https://winhelp2002.mvps.org/hosts.txt
7,1602886038,track.acclaimnetwork.com,https://winhelp2002.mvps.org/hosts.txt
8,1602886038,csh.actiondesk.com,https://winhelp2002.mvps.org/hosts.txt
9,1602886038,ads.activepower.net,https://winhelp2002.mvps.org/hosts.txt
```
To ingest this CSV file into a new topic and automatically create a schema for that topic, start a new Spooldir connector to watch for this source.  If you have CLI access, you can run:
```
./start_adhosts_spooldir.sh
```
Or you can upload the ```./scripts/adhosts_spooldir.json``` file by clicking "Upload connector config file" from within the Confluent Control Center UI.

Once this is started, or if it had already been started, the `ad_hosts.csv` file moves to:
```
./cp-zeek/spooldir/ad_hosts/csv_finished/ad_servers.csv
```
This means that if you are re-running the demonstration with a clean cluster you will need to ensure that you have moved it back to 
```
./cp-zeek/spooldir/ad_hosts/csv_input/ad_servers.csv
```

If you look under Topics, you should now see an topic called adhosts.

Create a stream from this topic so that ksqlDB can process it:
```sql
CREATE STREAM ADHOSTS_STREAM WITH (KAFKA_TOPIC='adhosts', VALUE_FORMAT='AVRO');
```

Because joining a stream to a stream requires a time window, and we want to consider our list of bad hostnames as more of a static snapshot, we will create a table from this stream:

```sql
CREATE TABLE adverts (id STRING, dateadded STRING, domain VARCHAR PRIMARY KEY, source VARCHAR)
WITH (KAFKA_TOPIC='adhosts', VALUE_FORMAT='AVRO');
```

So now we have a table against which we can match streaming events.


Create a new DNS stream that has the `"query"` value for its key:
```sql
CREATE STREAM KEYED_DNS WITH (KAFKA_TOPIC='keyed_dns', PARTITIONS=1, REPLICAS=1)
AS SELECT * FROM  DNS_STREAM
PARTITION BY "query"
EMIT CHANGES;
```
Now create a new stream with a join where the DNS query value matches an ad server hostname:
```sql
CREATE STREAM MATCHED_DOMAINS_DNS WITH (KAFKA_TOPIC='matched_dns', PARTITIONS=1, REPLICAS=1)
AS SELECT * FROM KEYED_DNS
INNER JOIN ADVERTS ADVERTS ON KEYED_DNS."query" = ADVERTS.DOMAIN
EMIT CHANGES;
```
This query creates a new stream `MATCHED_DOMAINS_DNS` that is backed by a new topic, `matched_dns` 

You can look for all DNS lookups that match any host listed in the ad_hosts.csv file with the following query:
```
SELECT * FROM  MATCHED_DOMAINS_DNS EMIT CHANGES;
```
