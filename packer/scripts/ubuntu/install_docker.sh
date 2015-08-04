#!/usr/bin/env bash
set -eux
set -o pipefail

sudo apt-get -y update
sudo apt-get install -y linux-image-extra-$(uname -r)

# This is a docker script from https://get.docker.com/ubuntu/. We added it here directly to downgrade docker version
# from 1.7.1 to 1.7.0. This is a temporary solution to get rid of the issue https://github.com/Capgemini/Apollo/issues/428.

# Check that HTTPS transport is available to APT
if [ ! -e /usr/lib/apt/methods/https ]; then
  sudo apt-get update
  sudo apt-get install -y apt-transport-https
fi
# Add the repository to your APT sources
sudo echo 'deb https://get.docker.com/ubuntu docker main' | tee /etc/apt/sources.list.d/docker.list
# Then import the repository key
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
# Install docker
sudo apt-get update
sudo apt-get install -y lxc-docker-${DOCKER_VERSION}

# Download docker containers to the machine to save download time on
# provisioning later
docker pull gliderlabs/consul:${CONSUL_VERSION}
docker pull gliderlabs/consul-agent:${CONSUL_VERSION}
docker pull gliderlabs/consul-server:${CONSUL_VERSION}
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
