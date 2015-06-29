#!/usr/bin/env bash
set -eux
set -o pipefail

sudo apt-get -y update
sudo apt-get install -y linux-image-extra-$(uname -r)
curl -sSL https://get.docker.com/ubuntu/ | sudo sh

# Download docker containers to the machine to save download time on
# provisioning later
docker pull gliderlabs/registrator:master
docker pull asteris/haproxy-consul:latest
docker pull weaveworks/weave:${WEAVE_VERSION}
docker pull weaveworks/scope:latest
docker pull mesosphere/marathon:v0.8.2


sudo service docker stop
echo manual | sudo tee /etc/init/docker.override >/dev/null
