#!/bin/bash

# Keeping atlas variable without prefix as it's been shared by consul and tf at the moment.
export ATLAS_TOKEN=${ATLAS_TOKEN:?"Need to set ATLAS_TOKEN non-empty"}
export ATLAS_INFRASTRUCTURE=${ATLAS_INFRASTRUCTURE:-capgemini/apollo}

export TF_VAR_user=${TF_VAR_user:?"Need to set User non-empty"}
export TF_VAR_access_key=${TF_VAR_access_key:?"Need to set TF_VAR_access_key non-empty"}
export TF_VAR_secret_key=${TF_VAR_secret_key:?"Need to set TF_VAR_secret_key non-empty"}
export TF_VAR_key_file=${TF_VAR_key_file:-$HOME/.ssh/apollo_aws_rsa}
export TF_VAR_key_name=${TF_VAR_key_name:-apollo}

# Overrides default folder in Terraform.py inventory.
export TF_VAR_STATE_ROOT="${APOLLO_ROOT}/terraform/aws"

export ANSIBLE_SSH_ARGS="-F ${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}/ssh.config -q"

export TF_VAR_region=${TF_VAR_region:-eu-west-1}
export TF_VAR_master_instance_type=${TF_VAR_master_instance_type:-m3.medium}
export TF_VAR_slave_instance_type=${TF_VAR_slave_instance_type:-m3.medium}
export TF_VAR_slaves=${TF_VAR_slaves:-1}
export TF_VAR_availability_zones=${TF_VAR_availability_zones:-'eu-west-1a,eu-west-1b,eu-west-1c'}
export TF_VAR_public_subnet_availability_zone=${TF_VAR_public_subnet_availability_zone:-'eu-west-1a'}
export APOLLO_consul_dc=${APOLLO_consul_dc:-$TF_VAR_region}
export APOLLO_mesos_cluster_name=${APOLLO_mesos_cluster_name:-$TF_VAR_region}
