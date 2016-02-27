#!/bin/bash

export TF_VAR_region=${TF_VAR_region:-LON}
export TF_VAR_auth_url=${TF_VAR_auth_url:-https://identity.api.rackspacecloud.com/v2.0}
export TF_VAR_mesos_slaves=${TF_VAR_mesos_slaves:-1}

# Overrides default folder in Terraform.py inventory.
export TF_VAR_STATE_ROOT="${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"

export APOLLO_consul_dc=${APOLLO_consul_dc:-$TF_VAR_region}
export APOLLO_mesos_cluster_name=${APOLLO_mesos_cluster_name:-$TF_VAR_region}
export APOLLO_ansible_ssh_user=root
export APOLLO_traefik_network_interface=eth0
