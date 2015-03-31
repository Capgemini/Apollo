#!/bin/bash
set -eo pipefail

sudo apt-get -y update
sudo apt-get install -y marathon

sudo service marathon stop
echo manual | sudo tee /etc/init/marathon.override >/dev/null
sudo mkdir -p /etc/marathon/conf
echo 300000 | sudo tee /etc/marathon/conf/task_launch_timeout >/dev/null
