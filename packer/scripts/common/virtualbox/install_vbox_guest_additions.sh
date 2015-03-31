#!/usr/bin/env bash
set -eu
set -o pipefail

VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
mkdir /tmp/isomount
mount -o loop /home/vagrant/VBoxGuestAdditions_$VBOX_VERSION.iso /tmp/isomount
/tmp/isomount/VBoxLinuxAdditions.run install
umount /tmp/isomount
rm -rf /tmp/isomount

# mountpoint for vagrant
sudo mkdir -p /vagrant

# Will return 0 if running or 1 if not
service vboxadd-service status | grep -v not