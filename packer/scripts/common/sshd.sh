#!/bin/bash
set -eo pipefail

# UseDNS is mostly useless and disabling speeds up logins
echo "UseDNS no" >> /etc/ssh/sshd_config
