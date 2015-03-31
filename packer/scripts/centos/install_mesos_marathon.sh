#!/bin/bash

set -eux
set -o pipefail

# Install Mesos
sudo rpm -Uvh http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm

sudo yum -y install mesos marathon mesosphere-zookeeper


sudo systemctl stop zookeeper.service
sudo systemctl disable zookeeper.service

sudo systemctl stop mesos-master.service
sudo systemctl disable mesos-master.service

sudo systemctl stop mesos-slave.service
sudo systemctl disable mesos-slave.service

echo 'docker,mesos' | sudo tee /etc/mesos-slave/containerizers >/dev/null
echo '10mins' | sudo tee /etc/mesos-slave/executor_registration_timeout >/dev/null

sudo systemctl stop marathon.service
sudo systemctl disable marathon.service

sudo mkdir -p /etc/marathon/conf
echo 300000 | sudo tee /etc/marathon/conf/task_launch_timeout >/dev/null
