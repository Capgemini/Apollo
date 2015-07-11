#!/bin/bash

# Keeping atlas variable without prefix as it's been shared by consul and tf at the moment.
export ATLAS_TOKEN=${ATLAS_TOKEN:?"Need to set ATLAS_TOKEN non-empty"}
export ATLAS_INFRASTRUCTURE=${ATLAS_INFRASTRUCTURE:-capgemini/apollo}

export TF_VAR_tenant_id=${TF_VAR_tenant_id:?"Need to set TF_VAR_tenant_id non-empty"}
export TF_VAR_username=${TF_VAR_username:?"Need to set TF_VAR_username non-empty"}
export TF_VAR_api_key=${TF_VAR_api_key:?"Need to set TF_VAR_api_key non-empty"}
export TF_VAR_password=${TF_VAR_password:?"Need to set TF_VAR_password non-empty"}

export TF_VAR_key_file=${TF_VAR_key_file:-$HOME/.ssh/apollo_openstack_rsa}
export TF_VAR_key_name=${TF_VAR_key_name:-deployer}

# Overrides default folder in Terraform.py inventory.
export TF_VAR_STATE_ROOT="${APOLLO_ROOT}/terraform/openstack"

export ANSIBLE_SSH_ARGS="-F ${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}/ssh.config -q"

# Terraform mappings needs to be statically passed as -var parameters
# so no really needed to export them. Exporting for consitency.
export TF_VAR_atlas_artifact_master=${TF_VAR_atlas_artifact_master:-capgemini/apollo-ubuntu-14.04-amd64}
export TF_VAR_atlas_artifact_slave=${TF_VAR_atlas_artifact_slave:-capgemini/apollo-ubuntu-14.04-amd64}
export TF_VAR_atlas_artifact_version_master=${TF_VAR_atlas_artifact_version_master:-1}
export TF_VAR_atlas_artifact_version_slave=${TF_VAR_atlas_artifact_version_slave:-1}

export TF_VAR_auth_url=${TF_VAR_auth_url:-'https://identity.api.rackspacecloud.com/v2.0'}
export TF_VAR_region=${TF_VAR_region:-LON}
export TF_VAR_master_size=${TF_VAR_master_size:-general1-1}
export TF_VAR_slave_size=${TF_VAR_slave_size:-general1-8}
export TF_VAR_slaves=${TF_VAR_slaves:-1}

export APOLLO_consul_dc=${APOLLO_consul_dc:-$TF_VAR_region}
export APOLLO_mesos_cluster_name=${APOLLO_mesos_cluster_name:-$TF_VAR_region}
