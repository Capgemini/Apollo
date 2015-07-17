#!/usr/bin/env bash
set -eux
set -o pipefail

# Latest Available Kernel version
LatestKernel="4.0.0-040000-generic"

# Required Packages
Headers_All="http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.19.8-vivid/linux-headers-3.19.8-031908_3.19.8-031908.201505110938_all.deb"
Headers_i386="http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.19.8-vivid/linux-headers-3.19.8-031908-generic_3.19.8-031908.201505110938_i386.deb"
Image_i386="http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.19.8-vivid/linux-image-3.19.8-031908-generic_3.19.8-031908.201505110938_i386.deb"
Headers_amd64="http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.19.8-vivid/linux-headers-3.19.8-031908-generic_3.19.8-031908.201505110938_amd64.deb"
Image_amd64="http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.19.8-vivid/linux-image-3.19.8-031908-generic_3.19.8-031908.201505110938_amd64.deb"

# Debian Packages
DEB="linux-headers-3.19.8*.deb linux-image-3.19.8*.deb"

# Currently Installed Kernel Version
CurrentKernel=$(uname -r) 

# System Architecture
SystemArch=$(uname -i)

# Check if System already has latest kernel installed
if [ "$CurrentKernel" = "$LatestKernel" ]
then
  echo "Wowsers! Your System is Already Updated to Latest Available Kernel Version!"
  echo "Program will now exit..."
  sleep 2s
  exit
fi

# If latest kernel is not available, then check the system architecture and download necessary packages

# For 32-bit Systems

if [ "$SystemArch" = "i386" ] || [ "$SystemArch" = "i686" ]
then

  echo "Kernel upgrade process for 32-bit systems will now start..."
  sleep 2s
  echo "Downloading required packages.."
  sleep 2s

  wget $Headers_All
  wget $Headers_i386
  wget $Image_i386

  echo "Download process completed. Packages are present in $(pwd) directory"
  sleep 2s

  echo "Installing the packages..."
  dpkg -i "$DEB"

# For 64-bit Systems
elif [ "$SystemArch" = "x86_64" ]
then
  echo "Kernel upgrade process for 64-bit systems will now start..." 
  sleep 2s

  wget $Headers_All
  wget $Headers_amd64
  wget $Image_amd64

  echo "Download process completed. Packages are present in $(pwd) directory"
  sleep 2s

  echo "Installing the packages..."
  dpkg -i "$DEB"

# If system architecture is not compatible
else
  echo "Packages for following system architecture not found :  $SystemArch"
  echo "Program will now exit..."
  sleep 2s
  exit
fi

echo "Your system has been successfully upgraded to latest kernel version $(LatestKernel)."
echo "System will now reboot."
reboot
sleep 60
