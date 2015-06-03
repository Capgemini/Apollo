#!/bin/bash

# Keeping atlas variable without prefix as it's been shared by consul and tf at the moment.
export ATLAS_TOKEN=${ATLAS_TOKEN:?"Need to set ATLAS_TOKEN non-empty"}
export ATLAS_INFRASTRUCTURE=${ATLAS_INFRASTRUCTURE:-capgemini/apollo}

export TF_VAR_account_file=${TF_VAR_account_file:?"Need to set TF_VAR_account_file non-empty"}
export TF_VAR_project=${TF_VAR_project:?"Need to set TF_VAR_project non-empty"}

# Terraform mappings needs to be statically passed as -var parameters
# so no really needed to export them. Exporting for consitency.
export TF_VAR_atlas_artifact_master=${TF_VAR_atlas_artifact_master:-capgemini/apollo-ubuntu-14.04-amd64}
export TF_VAR_atlas_artifact_slave=${TF_VAR_atlas_artifact_slave:-capgemini/apollo-ubuntu-14.04-amd64}

export TF_VAR_region=${TF_VAR_region:-europe-west1}
export TF_VAR_master_size=${TF_VAR_master_size:-n1-standard-2}
export TF_VAR_slave_size=${TF_VAR_slave_size:-n1-standard-2}
export TF_VAR_slaves=${TF_VAR_slaves:-1}
# Overrides default folder in Terraform.py inventory.
export TFSTATE_ROOT=`pwd`/terraform/gce

export APOLLO_consul_dc=${APOLLO_consul_dc:-$TF_VAR_region}
export APOLLO_mesos_cluster_name=${APOLLO_mesos_cluster_name:-$TF_VAR_region}
