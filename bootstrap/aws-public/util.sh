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
  if [[ "$(pip list | grep boto)" == "" ]]; then
    echo -e "${color_red}Can't find Boto. Please install it via pip install boto.${color_norm}"
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
    IdentityFile           $TF_VAR_key_file
    UserKnownHostsFile     /dev/null
EOF
  popd
}

ansible_playbook_run() {
  pushd $APOLLO_ROOT
    AWS_ACCESS_KEY_ID=${TF_VAR_access_key} AWS_SECRET_ACCESS_KEY=${TF_VAR_secret_key} \
    ANSIBLE_SSH_ARGS="-F $APOLLO_ROOT/terraform/${APOLLO_PROVIDER}/ssh.config -q" \
    ansible-playbook --user=ubuntu --inventory-file=$APOLLO_ROOT/inventory/${APOLLO_PROVIDER} \
    --extra-vars "consul_atlas_infrastructure=${ATLAS_INFRASTRUCTURE} \
      consul_atlas_join=true \
      consul_atlas_token=${ATLAS_TOKEN} \
      $(get_apollo_variables)" \
      --sudo site.yml
  popd
}

apollo_down() {
  pushd $APOLLO_ROOT/terraform/${APOLLO_PROVIDER}
    terraform destroy -var "access_key=${TF_VAR_access_key}" \
      -var "key_file=${TF_VAR_key_file}" \
      -var "region=${TF_VAR_region}"
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

open_urls() {
  pushd $APOLLO_ROOT/terraform/${APOLLO_PROVIDER}
    if [ -a /usr/bin/open ]; then
      /usr/bin/open "http://$(terraform output master.1.ip):5050"
      /usr/bin/open "http://$(terraform output master.1.ip):8080"
      /usr/bin/open "http://$(terraform output master.1.ip):8500"
    fi
  popd
}
