# Main Demo Script for cp-siem

## Notes for demonstrator

The script below has actions and a full talk track that can be used.  Spoke content will be in Bold.

All components used for this demo are dockerized and include

1. Full Confluent Platform
2. TCP replay - replaying a PCAP (packet capture) that was taken on a network during a data exfiltration attack (Note that PCAP data is usually in a binary format such as AVRO, SIEM vendors typically do not have great support for binary sources and resort to using logs for collecting the data. This is inefficient as pcap data can very a very high velocity of data)
3.  Zeek network sensor reading this network traffic and producing events directly into Confluent
4. Syslog events are being generated from from pcap an being sent to the Kafka Connector docker host on the standard syslog port
5. Cisco ASA (Adaptive Security Appliance) Events are being generated and sent to a splunk universalforwarder which is forwarding it to the Kafka Connedct docker host.

## Script

### Layout the Scenario

**I am going to demonstrate how Confluent can help a customer optimize their existing SIEM investment, while at the same time improving their cyber defense capabilities. For this demonstration I’m going to assume that the customer has in place Splunk (but we have helped customers modernize other SIEM platforms as well like ArcSight or QRadar).  
Not only has the customer invested money in the software but also time and resources in the deployment and operationalizing of it. As such the customer will already have data collection taking place with Splunk agents (universal forwarder and heavy forwarders) and potentially some other tools as well like rsyslog or Zeek/Corelight.  
Chances are all this data is going straight into Splunk and if not, it's being dropped.
My goals are to
1. **Decrease splunk costs both software, and hardware which can actually be more.**
2. **Start tapping into high volume data too expensive to index and put into splunk (and likely any SIEM)**
Avoid Splunk lock-in and enable the usage of other tools and ecosystems
Use S3 for longer term retention”
“So in the demo I am about to show you what I have is a complete dockerized environment which includes Confluent, Splunk, Splunk data generation, tcp replay that's replaying a packet capture taking during data exfiltration, zeek network sensor, the ELK stack, and the Confluent Sigma stream processor which looks for threats and patterns in real time.”  

