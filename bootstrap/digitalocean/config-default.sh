#!/bin/bash

# Keeping atlas variable without prefix as it's been shared by consul and tf at the moment.
ATLAS_TOKEN=${ATLAS_TOKEN:?"Need to set ATLAS_TOKEN non-empty"}
ATLAS_INFRASTRUCTURE=${ATLAS_INFRASTRUCTURE:-capgemini/apollo}

TF_VAR_region=${TF_VAR_region:-lon1}
TF_VAR_key_file=${TF_VAR_key_file:?"Need to set TF_VAR_key_file non-empty"}
TF_VAR_do_token=${TF_VAR_do_token:?"Need to set TF_VAR_do_token non-empty"}

TF_VAR_atlas_artifact_master=${TF_VAR_atlas_artifact_master:-capgemini/apollo-mesos-ubuntu-14.04-amd64}
TF_VAR_atlas_artifact_slave=${TF_VAR_atlas_artifact_slave:-capgemini/apollo-mesos-ubuntu-14.04-amd64}
TF_VAR_atlas_artifact_version_master=${TF_VAR_atlas_artifact_version_master:-1}
TF_VAR_atlas_artifact_version_slave=${TF_VAR_atlas_artifact_version_slave:-1}

TF_VAR_master_size=${TF_VAR_master_size:-512mb}
TF_VAR_slave_size=${TF_VAR_slave_size:-512mb}
TF_VAR_slaves=${TF_VAR_slaves:-1}

export APOLLO_consul_dc=${APOLLO_consul_dc:-$TF_VAR_region}
export APOLLO_mesos_cluster_name=${APOLLO_mesos_cluster_name:-$TF_VAR_region}
