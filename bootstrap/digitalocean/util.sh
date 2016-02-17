#!/bin/bash

# Use the config file specified in $APOLLO_CONFIG_FILE, or default to
# config-default.sh.
apollo_down() {
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"
    terraform destroy -var "do_token=${TF_VAR_do_token}"
  popd
}


