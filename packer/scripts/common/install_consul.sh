#!/bin/bash

cd /tmp/
wget https://dl.bintray.com/mitchellh/consul/${CONSUL_VERSION}_linux_amd64.zip -O consul.zip
echo Installing Consul...
unzip consul.zip
sudo chmod +x consul
sudo mv consul /usr/bin/consul
sudo mkdir /etc/consul.d
sudo chmod -R 777 /etc/consul.d
