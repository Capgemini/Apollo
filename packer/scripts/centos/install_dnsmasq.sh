#!/bin/bash

set -eux
set -o pipefail

yum install -y dnsmasq
chkconfig dnsmasq on

sudo systemctl stop dnsmasq.service
sudo systemctl disable dnsmasq.service
