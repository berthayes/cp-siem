# Analyzing Syslog data with ksqlDB
### Collecting ```sshd``` syslog events
If your Docker host is publicly facing and allows SSH connections from anywhere, a fun exercise can be to see who's trying to hack your host.

The Syslog connector is listening on port 5140/UDP.
- If your host is running rsyslog, add the following to /etc/rsyslog.conf:

  ```* @localhost:5140```

- Then restart rsyslog with:

  ```sudo /etc/init.d/rsyslog restart```

- Create a stream from the syslog data with the following ksqlDB query:

  ```CREATE STREAM SYSLOG_STREAM WITH (KAFKA_TOPIC='syslog', VALUE_FORMAT='AVRO');```

### To find attackers enumerating user accounts via ssh
Note: if also analyzing the included Syslog pcap, omit ```clonehost*``` hosts that were used to generate syslog data.

```sql
SELECT TIMESTAMP, 
TAG, MESSAGE, HOST, REMOTEADDRESS AS DEST_IP,
FORMAT_TIMESTAMP(FROM_UNIXTIME(TIMESTAMP), 'yyyy-MM-dd HH:mm:ss') AS EVENT_TIME, 
REGEXP_EXTRACT('Invalid user (.*) from', MESSAGE, 1) AS USER,
REGEXP_EXTRACT('Invalid user .* from (.*) port', MESSAGE, 1) AS SRC_IP,
GETGEOFORIP(REGEXP_EXTRACT('Invalid user .* from (.*) port', MESSAGE, 1)) AS GEOIP,
GETASNFORIP(REGEXP_EXTRACT('Invalid user .* from (.*) port', MESSAGE, 1)) AS ASNIP
FROM  SYSLOG_STREAM WHERE TAG='sshd' AND MESSAGE LIKE 'Invalid user%' AND  HOST NOT LIKE 'clonehost%'
EMIT CHANGES;
```

```json
{
  "TIMESTAMP": 1630446079000,
  "TAG": "sshd",
  "MESSAGE": "Invalid user testuser from 18.222.188.131 port 45332",
  "HOST": "ip-172-31-38-121",
  "DEST_IP": "192.168.16.1",
  "EVENT_TIME": "2021-08-31 21:41:19",
  "USER": "testuser",
  "SRC_IP": "18.222.188.131",
  "GEOIP": {
    "CITY": "Columbus",
    "COUNTRY": "United States",
    "SUBDIVISION": "Ohio",
    "LOCATION": {
      "LON": -83.0235,
      "LAT": 39.9653
    }
  },
  "ASNIP": {
    "ASN": 16509,
    "ORG": "AMAZON-02"
  }
}
```

