#!/usr/bin/env bash
set -eux
set -o pipefail

sudo apt-get -y update
sudo apt-get install -y marathon=${MARATHON_VERSION}

sudo service marathon stop || true
echo manual | sudo tee /etc/init/marathon.override >/dev/null
sudo mkdir -p /etc/marathon/conf
echo 300000 | sudo tee /etc/marathon/conf/task_launch_timeout >/dev/null
