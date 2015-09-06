#!/usr/bin/env bash
set -eux
set -o pipefail

sudo apt-get -y update

sudo pip install docker-py==1.3.1

sudo apt-get install -y linux-image-extra-$(uname -r)

# Install docker
# Add the repository to your APT sources
sudo echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' | tee /etc/apt/sources.list.d/docker.list
# Then import the repository key
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
# Install docker-engine
sudo apt-get update
sudo apt-get install -y docker-engine=${DOCKER_VERSION}

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
docker pull capgemini/dcos-cli:latest
docker pull andyshinn/dnsmasq:latest

sudo service docker stop
echo manual | sudo tee /etc/init/docker.override >/dev/null
