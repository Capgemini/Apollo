#!/usr/bin/env bash
set -eux
set -o pipefail

# The sleep 30 in the example above is very important.
# Because Packer is able to detect and SSH into the instance as soon as SSH is
# available, Ubuntu actually doesn't get proper amounts of time to initialize.
# The sleep makes sure that the OS properly initializes.
sleep 30
sudo apt-get upgrade -y
sudo apt-get update -y

sudo apt-get -y install linux-generic-lts-vivid git curl auditd audispd-plugins libcurl3 bridge-utils bundler default-jre-headless unzip wget python-setuptools python-protobuf cgroup-bin ruby2.0
sudo easy_install pip

sudo update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby2.0 1
sudo update-alternatives --install /usr/bin/gem gem /usr/bin/gem2.0 1
