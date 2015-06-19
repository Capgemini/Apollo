#!/usr/bin/env bash
set -eu
set -o pipefail

# UseDNS is mostly useless and disabling speeds up logins
echo "UseDNS no" >> /etc/ssh/sshd_config
