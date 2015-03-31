#!/bin/bash
set -eo pipefail

mkdir /tmp/isomount
mount -t iso9660 -o loop /home/vagrant/VBoxGuestAdditions.iso /tmp/isomount
/tmp/isomount/VBoxLinuxAdditions.run install
umount /tmp/isomount
rm -rf /tmp/isomount

# mountpoint for vagrant
sudo mkdir -p /vagrant
