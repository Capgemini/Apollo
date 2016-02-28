#!/bin/bash

# Keeping atlas variable without prefix as it's been shared by consul and tf at the moment.
export ATLAS_TOKEN=${ATLAS_TOKEN:?"Need to set ATLAS_TOKEN non-empty"}
export ATLAS_INFRASTRUCTURE=${ATLAS_INFRASTRUCTURE:-capgemini/apollo}

export TF_VAR_azure_settings_file=${TF_VAR_azure_settings_file:?"Need to set TF_VAR_azure_settings_file non-empty"}
export TF_VAR_user=${TF_VAR_user:?"Need to set User non-empty"}
export TF_VAR_username=${TF_VAR_username:?"Need to set TF_VAR_username non-empty"}

# Overrides default folder in Terraform.py inventory.
export TF_VAR_STATE_ROOT="${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"

export ANSIBLE_SSH_ARGS="-F ${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}/ssh.config -q"

# Terraform mappings needs to be statically passed as -var parameters
# so no really needed to export them. Exporting for consitency.
export TF_VAR_atlas_artifact_master=${TF_VAR_atlas_artifact_master:-apollo-ubuntu-14.04-amd64-1447838899}
export TF_VAR_atlas_artifact_slave=${TF_VAR_atlas_artifact_slave:-apollo-ubuntu-14.04-amd64-1447838899}
export TF_VAR_atlas_artifact_version_master=${TF_VAR_atlas_artifact_version_master:-1}
export TF_VAR_atlas_artifact_version_slave=${TF_VAR_atlas_artifact_version_slave:-1}

export TF_VAR_region=${TF_VAR_region:-North Europe}
export TF_VAR_master_size=${TF_VAR_master_size:-Medium}
export TF_VAR_slave_size=${TF_VAR_slave_size:-Medium}
export TF_VAR_slaves=${TF_VAR_slaves:-1}

# "datacenter" parameter in /etc/consul.d/consul.json file is set using the APOLLO_consul_dc
# variable. The parameter can't have spaces in its name so we replace them with underscores.
export APOLLO_consul_dc=${APOLLO_consul_dc:-${TF_VAR_region// /_}}
export APOLLO_mesos_cluster_name=${APOLLO_mesos_cluster_name:-$TF_VAR_region}
