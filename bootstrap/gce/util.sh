#!/bin/bash

# Use the config file specified in $APOLLO_CONFIG_FILE, or default to
# config-default.sh.
apollo_down() {
  pushd $APOLLO_ROOT/terraform/${APOLLO_PROVIDER}
    terraform destroy -var "region=${TF_VAR_region}"
  popd
}
