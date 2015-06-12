#!/usr/bin/env bash
set -eux
set -o pipefail

sudo apt-get -y update
curl -sSL https://get.docker.com/ubuntu/ | sudo sh

# Download docker containers to the machine to save download time on
# provisioning later
docker pull gliderlabs/registrator:master
docker pull asteris/haproxy-consul:latest
docker pull weaveworks/weave:${WEAVE_VERSION}
docker pull mysql:5.5
docker pull capgemini/apollo-commerce-kickstart:latest
docker pull mesosphere/marathon:${MARATHON_VERSION}

sudo service docker stop
echo manual | sudo tee /etc/init/docker.override >/dev/null
