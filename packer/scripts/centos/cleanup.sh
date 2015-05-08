#!/bin/bash

set -eux
set -o pipefail

# Based off the great "Preparing Linux Template VMs"
# (http://lonesysadmin.net/2013/03/26/preparing-linux-template-vms/) article
# by Bob Plankers, thanks Bob!

CLEANUP_PAUSE=${CLEANUP_PAUSE:-0}
echo "==> Pausing for ${CLEANUP_PAUSE} seconds..."
sleep ${CLEANUP_PAUSE}

echo "==> Cleaning up yum cache"
/usr/bin/yum clean all

echo "==> Force logs to rotate"
/usr/sbin/logrotate -f /etc/logrotate.conf
/bin/rm -f /var/log/*-???????? /var/log/*.gz

echo "==> Clear audit log and wtmp"
/bin/cat /dev/null > /var/log/audit/audit.log
/bin/cat /dev/null > /var/log/wtmp

echo "==> Cleaning up udev rules"
/bin/rm -f /etc/udev/rules.d/70*

echo "==> Remove the traces of the template MAC address and UUIDs"
/bin/sed -i '/^\(HWADDR\|UUID\)=/d' /etc/sysconfig/network-scripts/ifcfg-eth0

echo "==> Cleaning up tmp"
/bin/rm -rf /tmp/*
/bin/rm -rf /var/tmp/*

echo "==> Remove the SSH host keys"
/bin/rm -f /etc/ssh/*key*

echo "==> Remove the root user’s shell history"
/bin/rm -f ~root/.bash_history
unset HISTFILE

echo "==> Installed packages"
rpm -qa

# Determine the version of RHEL
COND=`grep -i " 6\." /etc/redhat-release`
if [ "$COND" = "" ]; then
export PREFIX="/usr/sbin"
else
export PREFIX="/sbin"
fi

FileSystem=`grep ext /etc/mtab| awk -F" " '{ print $2 }'`

for i in $FileSystem
do
echo $i
number=`df -B 512 $i | awk -F" " '{print $3}' | grep -v Used`
echo $number
percent=$(echo "scale=0; $number * 98 / 100" | bc )
echo $percent
dd count=`echo $percent` if=/dev/zero of=`echo $i`/zf
/bin/sync
sleep 15
rm -f $i/zf
done

# Make sure we wait until all the data is written to disk, otherwise
# Packer might quit too early before the large files are deleted
sync