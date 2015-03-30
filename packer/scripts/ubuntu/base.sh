#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get update -y

sudo apt-get -y install git curl libcurl3 default-jre-headless unzip wget python-setuptools python-protobuf cgroup-bin

`cd /tmp`

wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.18-vivid/linux-headers-3.18.0-031800-generic_3.18.0-031800.201412071935_amd64.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.18-vivid/linux-headers-3.18.0-031800_3.18.0-031800.201412071935_all.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.18-vivid/linux-image-3.18.0-031800-generic_3.18.0-031800.201412071935_amd64.deb
sudo dpkg -i linux-headers-3.18.0-*.deb linux-image-3.18.0-*.deb

# refresh grub bootloader and restart your computer
sudo update-grub