#!/bin/bash

yum install -y docker

sudo systemctl stop docker.service
sudo systemctl disable docker.service
