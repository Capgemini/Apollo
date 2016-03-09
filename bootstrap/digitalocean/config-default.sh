#!/bin/bash

export TF_VAR_region=${TF_VAR_region:-lon1}
export TF_VAR_do_token=${TF_VAR_do_token:?"Need to set TF_VAR_do_token non-empty"}

export ANSIBLE_SSH_ARGS="-F ${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}/ssh.config -i ${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}/id_rsa -q"

export APOLLO_consul_dc=${APOLLO_consul_dc:-$TF_VAR_region}
export APOLLO_mesos_cluster_name=${APOLLO_mesos_cluster_name:-$TF_VAR_region}
export APOLLO_ansible_ssh_user=core
export APOLLO_traefik_network_interface=eth1
