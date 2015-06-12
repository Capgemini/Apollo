#!/bin/bash

# Use the config file specified in $APOLLO_CONFIG_FILE, or default to
# config-default.sh.
APOLLO_ROOT=$(dirname "${BASH_SOURCE}")/../..
source "${APOLLO_ROOT}/bootstrap/${APOLLO_PROVIDER}/${APOLLO_CONFIG_FILE-"config-default.sh"}"

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
  if [[ "$(which python)" == "" ]]; then
    echo -e "${color_red}Can't find python in PATH, please fix and retry.${color_norm}"
    exit 1
  fi
}

apollo_launch() {
  terraform_apply
  ansible_ssh_config
  ansible_playbook_run
  open_urls
}

ansible_ssh_config() {
  pushd $APOLLO_ROOT/terraform/${APOLLO_PROVIDER}
    cat <<EOF > ssh.config
  Host *
    StrictHostKeyChecking  no
    ServerAliveInterval    120
    ControlMaster          auto
    ControlPath            ~/.ssh/mux-%r@%h:%p
    ControlPersist         30m
    User                   ubuntu
    UserKnownHostsFile     /dev/null
EOF
  popd
}

ansible_playbook_run() {
  pushd $APOLLO_ROOT
    get_ansible_inventory
    ANSIBLE_SSH_ARGS="-F $APOLLO_ROOT/terraform/${APOLLO_PROVIDER}/ssh.config -q"
    ansible-playbook --inventory-file=$APOLLO_ROOT/inventory \
    --extra-vars "consul_atlas_infrastructure=${ATLAS_INFRASTRUCTURE} \
      consul_atlas_join=true \
      consul_atlas_token=${ATLAS_TOKEN} \
      $(get_apollo_variables)" \
      --sudo site.yml
  popd
}

apollo_down() {
  pushd $APOLLO_ROOT/terraform/${APOLLO_PROVIDER}
    terraform destroy -var "region=${TF_VAR_region}"
  popd
}

terraform_apply() {
  pushd $APOLLO_ROOT/terraform/${APOLLO_PROVIDER}
    terraform apply -var "instance_type.master=${TF_VAR_master_size}" \
      -var "instance_type.slave=${TF_VAR_slave_size}" \
      -var "atlas_artifact.master=${TF_VAR_atlas_artifact_master}" \
      -var "atlas_artifact.slave=${TF_VAR_atlas_artifact_slave}"
  popd
}
