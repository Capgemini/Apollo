#!/bin/bash -eux

yum -y install wget bzip2 unzip

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

yum -y groupinstall "Development Tools"
yum -y install bc gcc make gcc-c++ kernel-devel-$(uname -r) kernel-headers-$(uname -r) curl-devel gettext-devel expat-devel zlib-devel openssl-devel readline-devel sqlite-devel perl nfs-utils fuse-libs cups perl-ExtUtils-MakeMaker asciidoc xmlto

# Make ssh faster by not waiting on DNS
echo "UseDNS no" >> /etc/ssh/sshd_config

# Install GIT 2.2.1
cd ~
wget -O git.zip https://github.com/git/git/archive/v2.2.1.zip
unzip git.zip
cd git-2.2.1
make configure
./configure --prefix=/usr/local
make all
sudo make install
echo 'pathmunge /usr/local/bin' > /etc/profile.d/git.sh
chmod +x /etc/profile.d/git.sh

yum -y upgrade
reboot &
service network stop
sleep 60
