# CP-SIEM
## Starting up
### Choosing your Docker host environment

- This demo (currently) runs 16 different Docker containers, so this might be too much for your laptop.
- Testing has been done on a c4.4xlarge EC2 instance, with good performance (probably over-provisioned).
- It's recommended to run ```docker system  prune -a``` before running ```docker-compose```

### Configuring the demo environment

- Running a really big pcap [optional]
  - The packet capture file included in this repository features DNS exfiltration (among other things), but will repeat itself after a few minutes.  This can be tiresome during a live demo or workshop.
  - Run ```python3 scripts/get_pcap.py``` script to download a 1GB/1hr playback pcap.
 

- Running NOT on ```localhost``` 
  - You need to advertise the correct public DNS hostname for the ksqlDB server to ensure that the ksqlDB editor in Confluent Control Center works without error. 
  - Run the ```./scripts/edit-docker-compose.sh``` script to change the ```localhost``` value in  ```CONTROL_CENTER_KSQL_KSQLDB1_ADVERTISED_URL: "http://localhost:8088"``` to whatever the public DNS hostname is for your EC2 instance.
  - Note: This only works in AWS (AFAIK)
  
### Starting the demo
- Cross your fingers
- Run ```docker-compose up -d```

If you are using sudo with docker-compose then you will likely need to use the -E option to sudo so it inherits your environmental variables so the last command will become ```sudo -E docker-compose up -d```

### Running the Demo
- This demo is a combination of three different reposistories:
  - [JohnnyMirza/confluent_splunk_demo](https://github.com/JohnnyMirza/confluent_splunk_demo)
  - [wlaforest/ConfluentCyberDemo](https://github.com/wlaforest/ConfluentCyberDemo)
  - [berthayes/cp-zeek](https://github.com/berthayes/cp-zeek)
- Each of these repositories has their own README files and walk-throughs.
- Some examples using ksqlDB for processing Zeek IDS data are included:
  - [Analyzing Syslog data with ksqlDB](https://github.com/berthayes/cp-siem/blob/main/syslog.md)
  - [Calculating bandwidth totals per host per hour](https://github.com/berthayes/cp-siem/blob/main/ksqldb.md)
  - [Filter on invalid SSL transactions & enrich new data stream](https://github.com/berthayes/cp-siem/blob/main/ssl.md)
- Watch this space for a new walk-through script that incorporates the best parts of all three.
