#!/bin/bash

export TF_VAR_tenant_name=${TF_VAR_tenant_name:?"Need to set TF_VAR_tenant_name non-empty"}
export TF_VAR_user_name=${TF_VAR_user_name:?"Need to set TF_VAR_user_name non-empty"}
export TF_VAR_password=${TF_VAR_password:?"Need to set TF_VAR_password non-empty"}

# Overrides default folder in Terraform.py inventory.
export TF_VAR_STATE_ROOT="${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"

export TF_VAR_region=${TF_VAR_region:-LON}

export APOLLO_consul_dc=${APOLLO_consul_dc:-$TF_VAR_region}
export APOLLO_mesos_cluster_name=${APOLLO_mesos_cluster_name:-$TF_VAR_region}
export APOLLO_ansible_ssh_user=core
