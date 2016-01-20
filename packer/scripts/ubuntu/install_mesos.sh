#!/usr/bin/env bash
set -eux
set -o pipefail

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list >/dev/null
sudo apt-get -y update

sudo apt-get install -y mesos=${MESOS_VERSION}

echo 'LD_LIBRARY_PATH=/usr/lib/jvm/java-8-oracle/jre/lib/amd64:/usr/lib/jvm/java-8-oracle/jre/lib/amd64/server' | sudo tee -a /etc/default/mesos

sudo service zookeeper stop
echo manual | sudo tee /etc/init/zookeeper.override >/dev/null
sudo service mesos-master stop || true
echo manual | sudo tee /etc/init/mesos-master.override >/dev/null
sudo service mesos-slave stop || true
echo manual | sudo tee /etc/init/mesos-slave.override >/dev/null
