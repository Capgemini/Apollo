#!/usr/bin/env bash
set -eux
set -o pipefail

sudo apt-get -y update
sudo apt-get install -y linux-image-extra-$(uname -r)
curl -sSL https://get.docker.com/ubuntu/ | sudo sh

# Download docker containers to the machine to save download time on
# provisioning later
docker pull mesosphere/mesos:${MESOS_VERSION}
docker pull mesosphere/mesos-master:${MESOS_VERSION}
docker pull mesosphere/mesos-slave:${MESOS_VERSION}
docker pull gliderlabs/registrator:master
docker pull asteris/haproxy-consul:latest
docker pull weaveworks/weave:${WEAVE_VERSION}
docker pull weaveworks/scope:latest
docker pull mesosphere/marathon:${MARATHON_VERSION}
docker pull mesosphere/chronos:${CHRONOS_VERSION}
docker pull capgemini/dcos-cli:latest
docker pull andyshinn/dnsmasq:latest

sudo service docker stop
echo manual | sudo tee /etc/init/docker.override >/dev/null
