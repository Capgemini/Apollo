#!/bin/bash

set -eux
set -o pipefail

yum install -y docker

sudo systemctl stop docker.service
sudo systemctl disable docker.service
