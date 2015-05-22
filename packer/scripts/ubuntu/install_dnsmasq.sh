#!/usr/bin/env bash
set -eux
set -o pipefail

apt-get install -y dnsmasq

sudo service dnsmasq stop
echo manual | sudo tee /etc/init/dnsmasq.override >/dev/null
