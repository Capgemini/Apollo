#!/bin/bash
ZK_IP=$(cat /tmp/zk_master)
sudo echo "zk://${ZK_IP}:2181/mesos" | sudo tee /etc/mesos/zk

sudo start mesos-slave
sudo start docker
