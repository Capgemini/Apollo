#!/usr/bin/env bash
set -eux
set -o pipefail

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list >/dev/null
sudo apt-get -y update

sudo apt-get install -y mesos=${MESOS_VERSION}

sudo service zookeeper stop
echo manual | sudo tee /etc/init/zookeeper.override >/dev/null
sudo service mesos-master stop || true
echo manual | sudo tee /etc/init/mesos-master.override >/dev/null
sudo service mesos-slave stop || true
echo manual | sudo tee /etc/init/mesos-slave.override >/dev/null
