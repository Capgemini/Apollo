#!/bin/bash

# Keeping atlas variable without prefix as it's been shared by consul and tf at the moment.
export ATLAS_TOKEN=${ATLAS_TOKEN:?"Need to set ATLAS_TOKEN non-empty"}
export ATLAS_INFRASTRUCTURE=${ATLAS_INFRASTRUCTURE:-capgemini/apollo}

export TF_VAR_access_key=${TF_VAR_access_key:?"Need to set TF_VAR_access_key non-empty"}
export TF_VAR_secret_key=${TF_VAR_secret_key:?"Need to set TF_VAR_secret_key non-empty"}

# Overrides default folder in Terraform.py inventory.
export TF_VAR_STATE_ROOT="${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"

export ANSIBLE_SSH_ARGS="-F ${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}/ssh.config -q"

export TF_VAR_region=${TF_VAR_region:-eu-west-1}
export APOLLO_consul_dc=${APOLLO_consul_dc:-$TF_VAR_region}
export APOLLO_mesos_cluster_name=${APOLLO_mesos_cluster_name:-$TF_VAR_region}
