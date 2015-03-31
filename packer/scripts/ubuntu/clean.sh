#!/usr/bin/env bash
set -eux
set -o pipefail

apt-get -y autoremove
apt-get -y clean
rm -rf VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?
