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

  check_terraform_version

  if [[ "$(which ansible-playbook)" == "" ]]; then
    echo -e "${color_red}Can't find ansible-playbook in PATH, please fix and retry.${color_norm}"
    exit 1
  fi
}

apollo_launch() {
  terraform_apply
  terraform_to_ansible
  ansible_playbook_run
  open_urls
}

ansible_playbook_run() {
  pushd $APOLLO_ROOT
    DO_API_TOKEN=$TF_VAR_do_token ansible-playbook --user=root \
    --inventory-file=$APOLLO_ROOT/inventory/digitalocean \
    --extra-vars "consul_atlas_infrastructure=${ATLAS_INFRASTRUCTURE} \
      consul_atlas_join=true \
      consul_atlas_token=${ATLAS_TOKEN} \
      $(get_apollo_variables)" \
    site.yml
  popd
}

apollo_down() {
  pushd $APOLLO_ROOT/terraform/digitalocean
    terraform destroy -var "do_token=${TF_VAR_do_token}" \
      -var "key_file=${TF_VAR_key_file}" \
      -var "region=${TF_VAR_region}"
  popd
}

terraform_apply() {
  pushd $APOLLO_ROOT/terraform/digitalocean
    # This variables need to be harcoded as Terraform does not support environment overriding for Mappings at the moment.
    terraform apply -var "instance_size.master=${TF_VAR_master_size}" \
      -var "instance_size.slave=${TF_VAR_slave_size}" \
      -var "atlas_artifact_version.master=${TF_VAR_atlas_artifact_version_master}" \
      -var "atlas_artifact_version.slave=${TF_VAR_atlas_artifact_version_slave}" \
      -var "atlas_artifact.master=${TF_VAR_atlas_artifact_master}" \
      -var "atlas_artifact.slave=${TF_VAR_atlas_artifact_slave}"
  popd
}
