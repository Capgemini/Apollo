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

check_terraform_version() {
  local IFS='.'
  local current_version_string="${2:-$( terraform --version | awk 'NR==1 {print $2}' )}"
  local requirement_version_string=${1:-0.6.1}
  local -a current_version=( ${current_version_string#'v'} )
  local -a requirement_version=( ${requirement_version_string} )
  local n diff
  local result=0

  for (( n=0; n<${#requirement_version[@]}; n+=1 )); do
    diff=$((current_version[n]-requirement_version[n]))
    if [ $diff -ne 0 ] ; then
      [ $diff -le 0 ] && result=1 || result=0
      break
    fi

  done

  echo "You are running Terraform ${current_version_string}..."
  if [ $result -eq 1 ]; then
    echo -e "${color_red}Terraform >= ${requirement_version_string} is required, please fix and retry.${color_norm}"
    exit 1
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
  get_terraform_modules
  terraform_apply
  run_if_exist "ansible_ssh_config"
  ansible_playbook_run
  run_if_exist "set_vpn"
  open_urls
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

  if [ -a /usr/bin/open ]; then
    /usr/bin/open "${master_url}:5050"
    /usr/bin/open "${master_url}:8080"
    /usr/bin/open "${master_url}:8500"
    /usr/bin/open "${master_url}:4040"
    /usr/bin/open "${master_url}:8081"
  fi
}

ansible_playbook_run() {
  pushd "${APOLLO_ROOT}"
    get_ansible_inventory
    ansible-playbook --inventory-file="${APOLLO_ROOT}/inventory" \
    ${ANSIBLE_LOG} --extra-vars "consul_atlas_infrastructure=${ATLAS_INFRASTRUCTURE} \
      consul_atlas_join=true \
      consul_atlas_token=${ATLAS_TOKEN} \
      $( get_apollo_variables  APOLLO_)" \
    --sudo site.yml
  popd
}

get_ansible_inventory() {
    pushd $APOLLO_ROOT
    if [ ! -f inventory/terraform.py ]; then
      curl -sS https://raw.githubusercontent.com/Capgemini/terraform.py/master/terraform.py -o inventory/terraform.py
      chmod 755 inventory/terraform.py
    fi
    popd
}

get_terraform_modules() {
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"
    # Downloads terraform modules.
    terraform get
  popd
}

terraform_apply() {
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"
    # This variables need to be harcoded as Terraform does not support environment overriding for Mappings at the moment.
    terraform apply -var "instance_type.master=${TF_VAR_master_size}" \
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
