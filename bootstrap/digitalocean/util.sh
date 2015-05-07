#!/bin/bash

# Use the config file specified in $APOLLO_CONFIG_FILE, or default to
# config-default.sh.
APOLLO_ROOT=$(dirname "${BASH_SOURCE}")/../..
source "${APOLLO_ROOT}/bootstrap/digitalocean/${APOLLO_CONFIG_FILE-"config-default.sh"}"

verify_prereqs() {
  if [[ "$(which terraform)" == "" ]]; then
    echo -e "${color_red}Can't find terraform in PATH, please fix and retry.${color_norm}"
    exit 1
  fi
  if [[ "$(which ansible-playbook)" == "" ]]; then
    echo -e "${color_red}Can't find ansible-playbook in PATH, please fix and retry.${color_norm}"
    exit 1
  fi
}

apollo_launch() {
  terraform_apply
  ansible_playbook_run
  open_urls
}

ansible_playbook_run() {
  pushd $APOLLO_ROOT
    DO_CLIENT_ID=$DO_CLIENT_ID DO_API_KEY=$DO_API_KEY ansible-playbook --user=root \
    --inventory-file=$APOLLO_ROOT/inventory/digitalocean \
    --extra-vars "mesos_cluster_name=${MESOS_CLUSTER_NAME} \
      consul_dc=${CONSUL_DC} \
      consul_atlas_infrastructure=${ATLAS_INFRASTRUCTURE} \
      consul_atlas_join=true \
      consul_atlas_token=${ATLAS_TOKEN}" \
    site.yml
  popd
}

apollo_down() {
  pushd $APOLLO_ROOT/terraform/digitalocean
    terraform destroy -var "do_token=${DIGITALOCEAN_API_TOKEN}" \
      -var "key_file=${DIGITALOCEAN_SSH_KEY}" \
      -var "region=${DIGITALOCEAN_REGION}"
  popd
}

terraform_apply() {
  pushd $APOLLO_ROOT/terraform/digitalocean
    terraform apply -var "do_token=${DIGITALOCEAN_API_TOKEN}" \
      -var "key_file=${DIGITALOCEAN_SSH_KEY}" \
      -var "instance_size.master=${MASTER_SIZE}" \
      -var "instance_size.slave=${SLAVE_SIZE}" \
      -var "atlas_artifact.master=${ATLAS_ARTIFACT_MASTER}" \
      -var "atlas_artifact.slave=${ATLAS_ARTIFACT_SLAVE}" \
      -var "slaves=${NUM_SLAVES}" \
      -var "region=${DIGITALOCEAN_REGION}"
  popd
}

open_urls() {
  pushd $APOLLO_ROOT/terraform/digitalocean
    /usr/bin/open "http://$(terraform output master.1.ip):5050"
    /usr/bin/open "http://$(terraform output master.1.ip):8080"
    /usr/bin/open "http://$(terraform output master.1.ip):8500"
  popd
}
