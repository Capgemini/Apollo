#!/bin/sh
set -e

azure config mode asm

azure service cert create $1 ~/.ssh/id_rsa_azure.pfx

azure service cert list | \
  grep $1 | \
  awk '{print $3}' | tr -d '\n' > ssh_thumbprint
