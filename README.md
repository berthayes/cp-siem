# CP-SIEM
## Starting up
###Choosing your Docker host environment

- This demo (currently) runs 16 different Docker containers, so this might be too much for your laptop.
- Testing has been done on a c4.4xlarge EC2 instance, with good performance.
- It's recommended to run ```docker system  prune -a``` before running ```docker-compose```

###Configuring the demo environment

- Running a really big pcap
  - Run the ```scripts/get_pcap.py``` script to download a 1GB/1hr playback pcap featuring DNS exfiltration

- Running NOT on ```localhost``` and getting the ksqlDB editor to work
  - Run the ```scripts/edit-docker-compose.sh``` script to change the ```localhost``` value in  ```CONTROL_CENTER_KSQL_KSQLDB1_ADVERTISED_URL: "http://localhost:8088"``` to whatever the public DNS hostname is for your EC2 instance.
  
###Starting the demo
- Cross your fingers
- Run ```docker-compose up -d```