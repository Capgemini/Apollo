#!/bin/bash

# Util functions cloud reusable.
APOLLO_ROOT=$(dirname "${BASH_SOURCE}")/..
DEFAULT_CONFIG="${APOLLO_ROOT}/bootstrap/${APOLLO_PROVIDER}/${APOLLO_CONFIG_FILE-"config-default.sh"}"
APOLLO_INVENTORY="${APOLLO_INVENTORY-inventory}"
APOLLO_PLAYBOOK="${APOLLO_PLAYBOOK-site.yml}"

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
  local requirement_version_string=${1:-0.6.12}
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
  if [[ "$@" == "-i" ]]; then
    get_terraform_modules
    terraform_apply
    run_if_exist "ansible_ssh_config"
    ansible_playbook_run
    run_if_exist "set_vpn"
    open_urls
  elif [ "$@" ]; then
    eval $@
  else
    get_terraform_modules
    terraform_apply
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
    install_contributed_roles
    ansible-playbook --inventory-file="${APOLLO_ROOT}/${APOLLO_INVENTORY}" \
    --tags "${ANSIBLE_TAGS:-all}" \
    ${ANSIBLE_LOG} --extra-vars "$( get_apollo_variables  APOLLO_)" \
    ${ANSIBLE_EXARGS:-} \
    ${APOLLO_PLAYBOOK}
  popd
}

ansible_dcos_install() {
  export APOLLO_PLAYBOOK='dcos.yml'
  ansible_playbook_run
}

ansible_upgrade_mesoscluster() {
  export APOLLO_PLAYBOOK='rolling-upgrade-mesoscluster.yml'
  ansible_playbook_run
}

ansible_upgrade_maintenance() {
  export APOLLO_PLAYBOOK='rolling-upgrade-maintenance.yml'
  ansible_playbook_run
}

install_contributed_roles() {
  pushd "${APOLLO_ROOT}"
    ansible-galaxy install --force -r contrib-plugins/plugins.yml
    ansible-galaxy install --force -r requirements.yml
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

    # Make any dependencies
    if ls -1 .terraform/modules/*/Makefile >/dev/null 2>&1; then
      for dir in .terraform/modules/*/Makefile;
      do
        make -C $(/usr/bin/dirname $dir)
      done
    fi
  popd
}

terraform_apply() {
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"
    terraform apply
  popd
}

# Helper function to get the fist octet of an IPv4 address.
get_network_identifier() {
  ip="$1"
  echo $(echo $ip | tr "." " " | awk '{ print $1 }')
}
