#!/bin/bash

# Use the config file specified in $APOLLO_CONFIG_FILE, or default to
# config-default.sh.
apollo_down() {
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"
    terraform destroy -var "tenant_name=${TF_VAR_tenant_name}" -var "user_name=${TF_VAR_user_name}" -var "password=${TF_VAR_password}"
    # Clear contents of etcd_discovery_url.txt file to avoid polluting the repo by pusing unecessary content.
    > ${TF_VAR_etcd_discovery_url_file:-etcd_discovery_url.txt}
  popd
}
