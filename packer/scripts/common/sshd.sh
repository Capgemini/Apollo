#!/bin/bash

# UseDNS is mostly useless and disabling speeds up logins
echo "UseDNS no" >> /etc/ssh/sshd_config
