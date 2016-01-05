#!/bin/bash

# Util functions cloud reusable.
APOLLO_ROOT=$(dirname "${BASH_SOURCE}")/..
DEFAULT_CONFIG="${APOLLO_ROOT}/bootstrap/${APOLLO_PROVIDER}/${APOLLO_CONFIG_FILE-"config-default.sh"}"
if [ -f "${DEFAULT_CONFIG}" ]; then
  source "${DEFAULT_CONFIG}"
fi

verify_prereqs() {
  if [[ "$(which terraform)" == "" ]]; then
    echo -e "${color_red}Can't find terraform in PATH, please fix and retry.${color_norm}"
    exit 1
  fi

  check_terraform_version 0.6.9-dev

  if [[ "$(which ansible-playbook)" == "" ]]; then
    echo -e "${color_red}Can't find ansible-playbook in PATH, please fix and retry.${color_norm}"
    exit 1
  fi
  if [[ "$(which python)" == "" ]]; then
    echo -e "${color_red}Can't find python in PATH, please fix and retry.${color_norm}"
    exit 1
  fi
}

check_terraform_version() {
  local required_version=${1:-0.6.9}
  local current_version_string="$( terraform --version | awk 'NR==1 {print $2}' )"
  local current_version=${current_version_string#'v'}

  if [[ ${current_version} != ${required_version} ]]; then
    echo -e "${color_red}Terraform ${required_version} is required, please fix and retry.${color_norm}"
  fi
}

get_apollo_variables() {
  local plugin_namespace=${1:-"APOLLO_"}
  local -a var_list=()
  local IFS=$'\n'

  for env_var in $( env | grep "${plugin_namespace}" ); do
    # This deletes shortest match of $substring from front of $string. ${string#substring}
    var_value=${env_var#${plugin_namespace}}

    var=$( echo "${var_value}" | awk -F = '{ print $1 }' )
    value=${var_value#*=}
    var_list+=( "${var}='${value}'" )
  done
  echo "${var_list[@]}"
}

apollo_launch() {
  if [[ "$@" == "-i" ]]; then
    get_terraform_modules
    run_terraform apply
    run_if_exist "ansible_ssh_config"
    ansible_playbook_run
    run_if_exist "set_vpn"
    open_urls
  elif [[ "$@" != "" ]]; then
    eval $@
  else
    get_terraform_modules
    run_terraform apply
    run_if_exist "ansible_ssh_config"
    ansible_playbook_run
    run_if_exist "set_vpn"
  fi
}

run_if_exist() {
  if [ "$(type -t "${1}")" = function ]; then
    $1
  fi
}

get_master_url() {
  local master_url=''

  if [[ $APOLLO_PROVIDER == "vagrant" ]]; then
    master_url="http://master1"
  else
    pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}" > /dev/null
      master_url="http://$(terraform output master.1.ip)"
    popd > /dev/null
  fi

  echo "${master_url}"
}

open_urls() {
  local master_url=$(get_master_url)
  local open_cmd=""

  if [ -a /usr/bin/open ]; then
    open_cmd=/usr/bin/open
  elif [ -a /usr/bin/xdg-open ]; then
    open_cmd=/usr/bin/xdg-open
  elif start; then
    open_cmd=start
  fi

  if [ -a ${open_cmd} ]; then
    "${open_cmd}" "${master_url}:5050"
    "${open_cmd}" "${master_url}:8080"
    "${open_cmd}" "${master_url}:8500"
  fi
}

ansible_playbook_run() {
  pushd "${APOLLO_ROOT}"
    get_ansible_inventory
    get_ansible_requirements
    ansible-playbook --inventory-file="${APOLLO_ROOT}/inventory" \
    ${ANSIBLE_LOG} --extra-vars "consul_atlas_infrastructure=${ATLAS_INFRASTRUCTURE} \
      consul_atlas_join=true \
      consul_atlas_token=${ATLAS_TOKEN} \
      $( get_apollo_variables  APOLLO_)" \
    ${ANSIBLE_EXARGS:-} \
    --sudo ${1-site.yml}
  popd
}

get_ansible_inventory() {
    pushd $APOLLO_ROOT
    if [ ! -f inventory/terraform.py ]; then
      curl -sS https://raw.githubusercontent.com/Udacity/terraform.py/master/terraform.py -o inventory/terraform.py
      chmod 755 inventory/terraform.py
    fi
    popd
}

get_ansible_requirements() {
    pushd $APOLLO_ROOT
    if [ ! -d roles/datadog-agent ]; then
        ansible-galaxy install -r requirements.yml --ignore-errors --force
    fi
    popd
}

get_terraform_modules() {
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"
    # Downloads terraform modules.
    terraform get
  popd
}

run_terraform() {
  if [ ! "${1:-}" ]; then
    echo "run_terraform requires an argument (plan, apply)"
    exit 1
  fi
  local terraform_action=${1}
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"
    # This variables need to be harcoded as Terraform does not support environment overriding for Mappings at the moment.
    terraform ${terraform_action} -var "instance_type.master=${TF_VAR_master_size}" \
      -var "instance_type.slave=${TF_VAR_slave_size}" \
      -var "atlas_artifact_version.master=${TF_VAR_atlas_artifact_version_master}" \
      -var "atlas_artifact_version.slave=${TF_VAR_atlas_artifact_version_slave}" \
      -var "atlas_artifact.master=${TF_VAR_atlas_artifact_master}" \
      -var "atlas_artifact.slave=${TF_VAR_atlas_artifact_slave}"
  popd
}

# Helper function to get the fist octet of an IPv4 address.
get_network_identifier() {
  ip="$1"
  echo $(echo $ip | tr "." " " | awk '{ print $1 }')
}
