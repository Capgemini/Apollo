#!/bin/bash
sudo apt-get install -y marathon
echo manual | sudo tee /etc/init/mesos-slave.override
sudo service zookeeper start
sudo start mesos-master
sudo start marathon