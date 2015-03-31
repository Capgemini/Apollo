#!/bin/bash

set -eux
set -o pipefail

yum install -y dnsmasq
chkconfig dnsmasq on

sudo systemctl stop dnsmasq.service
sudo systemctl disable dnsmasq.service
echo "server=/consul/127.0.0.1#8600" > /etc/dnsmasq.d/10-consul
