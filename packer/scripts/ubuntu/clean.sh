#!/bin/bash

apt-get -y autoremove
apt-get -y clean
rm -rf VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?
