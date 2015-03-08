#!/bin/bash
# Setup Repos so we only have to run apt-get update once
# Docker
sudo apt-get install -y wget
echo "deb http://get.docker.io/ubuntu docker main" | sudo tee /etc/apt/sources.list.d/docker.list
wget -qO- https://get.docker.io/gpg | sudo apt-key add -
# Mesos
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
# Install packages
echo "installing packages"
sudo apt-get update
sudo apt-get install -y openjdk-7-jre-headless libcurl3
sudo apt-get install -y lxc-docker
sudo apt-get install -y mesos
sudo service zookeeper stop