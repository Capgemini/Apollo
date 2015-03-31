#!/usr/bin/env bash
set -eu
set -o pipefail

apt-get install -y dnsmasq

sudo service dnsmasq stop
echo manual | sudo tee /etc/init/dnsmasq.override >/dev/null
echo "server=/consul/127.0.0.1#8600" > /etc/dnsmasq.d/10-consul
