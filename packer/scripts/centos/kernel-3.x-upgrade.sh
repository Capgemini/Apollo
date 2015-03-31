#!/bin/bash

set -eux
set -o pipefail

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm

yum --enablerepo=elrepo-kernel -y install kernel-ml kernel-ml-devel

# Once the installation is finished, make sure you have got new kernel.
awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg

grub2-set-default 0
grub2-mkconfig -o /boot/grub2/grub.cfg

reboot
sleep 60