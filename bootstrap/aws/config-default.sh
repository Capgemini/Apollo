#!/bin/bash

USER=${USER:?"Need to set User non-empty"}
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:?"Need to set AWS_ACCESS_KEY_ID non-empty"}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:?"Need to set AWS_SECRET_ACCESS_KEY non-empty"}
AWS_SSH_KEY=${AWS_SSH_KEY:-$HOME/.ssh/apollo_aws_rsa}
AWS_SSH_KEY_NAME=${AWS_SSH_KEY_NAME:-apollo}
ATLAS_TOKEN=${ATLAS_TOKEN:?"Need to set ATLAS_TOKEN non-empty"}
ATLAS_INFRASTRUCTURE=${ATLAS_INFRASTRUCTURE:-capgemini/apollo}
ATLAS_ARTIFACT_MASTER=${ATLAS_ARTIFACT_MASTER:-capgemini/apollo-mesos-ubuntu-14.04-amd64}
ATLAS_ARTIFACT_SLAVE=${ATLAS_ARTIFACT_SLAVE:-capgemini/apollo-mesos-ubuntu-14.04-amd64}
ZONE=${APOLLO_AWS_ZONE:-eu-west-1b}
MASTER_SIZE=${MASTER_SIZE:-m1.medium}
SLAVE_SIZE=${SLAVE_SIZE:-m1.medium}
NUM_SLAVES=${NUM_SLAVES:-1}

# This removes the final character in bash (somehow)
AWS_REGION=${ZONE%?}
CONSUL_DC=${CONSUL_DC:-$AWS_REGION}
MESOS_CLUSTER_NAME=${MESOS_CLUSTER_NAME:-$AWS_REGION}
