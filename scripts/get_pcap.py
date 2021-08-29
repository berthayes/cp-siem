import os
import requests

# This script pulls a 1GB pcap file from an open S3 bucket
# TODO: pull the bucket/object values from a config file

print("Renaming existing zeek_streamer.pcap file")
os.rename('./pcaps/zeek_streamer.pcap', './pcaps/zeek_streamer.pcap.bak')

url = 'https://bhayes-pcaps.s3.us-east-2.amazonaws.com/garage-2020-10-18.pcap'
headers = {'Host': 'bhayes-pcaps.s3.us-east-2.amazonaws.com'}
print("Downloading pcap file...")
r = requests.get(url, headers=headers)
pcap_binary = r.content

print("Writing file to disk...")
with open("./pcaps/zeek_streamer.pcap", "wb") as pcap:
    pcap.write(pcap_binary)

print("Done")