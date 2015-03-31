#!/usr/bin/env bash
set -eu
set -o pipefail

sudo apt-get upgrade -y
sudo apt-get update -y

sudo apt-get -y install git curl libcurl3 default-jre-headless unzip wget python-setuptools python-protobuf cgroup-bin ruby1.9.1
