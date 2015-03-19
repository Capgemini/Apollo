#!/bin/bash

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list >/dev/null
sudo apt-get -y update

sudo apt-get install -y mesos

sudo service zookeeper stop
echo manual | sudo tee /etc/init/zookeeper.override >/dev/null
sudo service mesos-master stop
echo manual | sudo tee /etc/init/mesos-master.override >/dev/null
sudo service mesos-slave stop
echo manual | sudo tee /etc/init/mesos-slave.override >/dev/null

echo 'docker,mesos' | sudo tee /etc/mesos-slave/containerizers >/dev/null
echo '10mins' | sudo tee /etc/mesos-slave/executor_registration_timeout >/dev/null
