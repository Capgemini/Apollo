#!/bin/bash

sudo apt-get -y update
curl -sSL https://get.docker.com/ubuntu/ | sudo sh
sudo service docker stop
echo manual | sudo tee /etc/init/docker.override >/dev/null

-d -s overlay