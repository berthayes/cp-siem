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

**I am going to demonstrate how Confluent can help a customer optimize their existing SIEM investment, while at the same time improving their cyber defense capabilities. For this demonstration I’m going to assume that the customer has in place Splunk (but we have helped customers modernize other SIEM platforms as well like ArcSight or QRadar).**

**Not only has the customer invested money in the software but also time and resources in the deployment and operationalizing of it. As such the customer will already have data collection taking place with Splunk agents (universal forwarder and heavy forwarders) and potentially some other tools as well like rsyslog or Zeek/Corelight.  Chances are all this data is going straight into Splunk and if not, it's being dropped.**

**My goals are to**
1. **Decrease splunk costs both software, and hardware which can actually be more.**
2. **Start tapping into high volume data too expensive to index and put into splunk (and likely any SIEM)
3. **Avoid Splunk lock-in and enable the usage of other tools and ecosystems**
4. **Use S3 for longer term retention**
**So in the demo I am about to show you what I have is a complete dockerized environment which includes Confluent, Splunk, Splunk data generation, tcp replay that's replaying a packet capture taking during data exfiltration, zeek network sensor, the ELK stack, and the Confluent Sigma stream processor which looks for threats and patterns in real time.**

### Show the current state of Confluent
**Let me start by going to Confluent Control center to give you a quick look at what’s happening presently after I have spun up these containers**
1. Go to C3 at [http://cp-siem.hopto.me:9021](http://cp-siem.hopto.me:9021) (or other host URL if running elswhere)
2. Go to topics.  **You can see we have a number of already existing topics in this new environment.  Most of these were created by and are receiving data from the Zeek container I briefly mentioned.  Zeek is a very common tool in cyber defense and is an open source network sensor that reads packet traffic and produces metadata about that activity on the network.  For instance you can see topics for socket connections, dns queries, http requests, running applications, etc.  We also have some precreated topics that will be used by our real time stream processor. Zeek is a good example of one of the many tools in this domain that have native support for producing directly into Kafka.  Other examples are things like syslog-ng, r-syslog, beats, blue coat proxy, etc**


### Demonstrate the ease of bringing in sources of data Connectors.

**While many data producers support writing straight to kafka some do not OR in some cases you want to receive data from a standard protocol.  We are going to show you how you can easily spin up our off the shelf connectors for those situations.  A standard data source in Cyber defense are system logs (syslog) so lets start capturing that.**

1. Go to the connector cluster, click add connector, and select SyslogSourceConnector.  “So you can in this case I am selecting the SyslogSourceConnector.
Go to the Listener section. “If you aren’t familiar with Kafka Connect you can see it presents you will all the various settings that can be applied but almost all of these are optional with a reasonable default.  All I have to do with this connector is to specify which syslog protocol to use and which port to receive events on.”
Set `syslog.listener` -> `UDP`, and `syslog.port` -> `5140`.  Click next.  
2. **Control center actually generates the configuration required by the Connect cluster and will send it via the restful API.  So you can just as easily automate this using your favorite tool, or use gitops to store the connectors you need for your cluster etc…”** Click Launch (it will take a few seconds for the connector to show up). 
3. **As mentioned earlier, the customer already has Splunk deployed including forwarders to collect data which then sends it straight to Splunk.  In order to optimize this data and leverage other additional tools, we want to send the data to Confluent instead.  So let's spin another connector to receive this data.”** Click add connector and this time select the `SplunkS2SSourceConnector`.
4.  **For this one we don’t need to specify anything at all and will just stick with the defaults.** Scroll to the bottom of the screen select `Next` and then on the following screen select `Submit.`
5. Show the data flowing into Confluent from the two connectors: **So at this point let's actually go back and take a quick peek into the topics to see what the data looks like.**
