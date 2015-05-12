#!/bin/bash

# Keeping atlas variable without prefix as it's been shared by consul and tf at the moment.
ATLAS_TOKEN=${ATLAS_TOKEN:?"Need to set ATLAS_TOKEN non-empty"}
ATLAS_INFRASTRUCTURE=${ATLAS_INFRASTRUCTURE:-capgemini/apollo}

TF_VAR_user=${TF_VAR_user:?"Need to set User non-empty"}
TF_VAR_access_key=${TF_VAR_access_key:?"Need to set TF_VAR_access_key non-empty"}
TF_VAR_secret_key=${TF_VAR_secret_key:?"Need to set TF_VAR_secret_key non-empty"}
TF_VAR_key_file=${TF_VAR_key_file:-$HOME/.ssh/apollo_aws_rsa}
TF_VAR_key_name=${TF_VAR_key_name:-apollo}

TF_VAR_atlas_artifact_master=${TF_VAR_atlas_artifact_master:-capgemini/apollo-mesos-ubuntu-14.04-amd64}
TF_VAR_atlas_artifact_slave=${TF_VAR_atlas_artifact_slave:-capgemini/apollo-mesos-ubuntu-14.04-amd64}

TF_VAR_region=${TF_VAR_region%?:-eu-west-1b}
TF_VAR_master_size=${TF_VAR_master_size:-m1.medium}
TF_VAR_slave_size=${TF_VAR_slave_size:-m1.medium}
TF_VAR_slaves=${TF_VAR_slaves:-1}
TF_VAR_subnet_availability_zone=${TF_VAR_region}

APOLLO_consul_dc=${APOLLO_consul_dc:-$TF_VAR_region}
APOLLO_mesos_cluster_name=${APOLLO_mesos_cluster_name:-$TF_VAR_region}
