#!/usr/bin/env bash
set -eux
set -o pipefail

# The sleep 30 in the example above is very important.
# Because Packer is able to detect and SSH into the instance as soon as SSH is
# available, Ubuntu actually doesn't get proper amounts of time to initialize.
# The sleep makes sure that the OS properly initializes.
sleep 30
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get upgrade -y
sudo apt-get update -y

sudo apt-get -y install git curl libcurl3 bridge-utils bundler unzip wget python-setuptools python-protobuf cgroup-bin ruby1.9.1
sudo easy_install pip

# install java8
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer

