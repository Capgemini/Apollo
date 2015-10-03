#!/usr/bin/env bash
set -eu
set -o pipefail

# UseDNS is mostly useless and disabling speeds up logins
sed -i '$a UseDNS no' /etc/ssh/sshd_config
