#!/bin/bash

# Util functions cloud reusable.

get_apollo_variables() {
  local plugin_namespace=${1:-"APOLLO_"}
  local var_list=()
  local IFS=$'\n'

  for env_var in $( env | grep ${plugin_namespace} ); do
  	# This deletes shortest match of $substring from front of $string. ${string#substring}
    var_value=${env_var#${plugin_namespace}}

    var=$( echo $var_value | awk -F = '{ print $1 }' )
    value=$( echo $var_value | awk -F = '{ print $2 }' )
    var_list+=( "${var}='${value}'" )
  done
  echo ${var_list[@]}
}

check_terraform_version() {

  local IFS='.'
  local current_version_string=`terraform --version | awk 'NR==1 {print $2}'`
  local requirement_version_string=${1:-0.5.0}
  local -a current_version=( ${current_version_string#'v'} )
  local -a requirement_version=( ${requirement_version_string} )
  local n diff
  local result=0
  echo "You are running Terraform ${current_version_string}..."

  for (( n=0; n<${#requirement_version[@]}; n+=1 )); do
    diff=$((current_version[n]-requirement_version[n]))
    if [ $diff -ne 0 ] ; then
      [ $diff -le 0 ] && result=1 || result=0
      break
    fi

  done

  if [ $result -eq 1 ]; then
    echo -e "${color_red}Terraform >= ${requirement_version_string} is required, please fix and retry.${color_norm}"
    exit 1
  fi
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

# Creates "zk://1.1.1.1:2181,2.2.2.2:2181/mesos" from "1.1.1.1,2.2.2.2"
mesos_zk_url_terraform_to_ansible() {
  local IFS=','
  local ips_string=$1
  local ips=( ${ips_string} )
  local number_of_servers=${#ips[@]}
  local last_server=$(( number_of_servers-1 ))
  local IFS=''
  local mesos_zk_url=''

  for (( n=0; n<$number_of_servers; n+=1 )); do
    mesos_zk_url="${mesos_zk_url}${ips[n]}:2181"
    if [ "${n}" -ne "${last_server}" ]; then
      mesos_zk_url="${mesos_zk_url},"
    fi
  done
  mesos_zk_url="zk://${mesos_zk_url}/mesos"
  echo "${mesos_zk_url}"
}

# Creates "1.1.1.1 2.2.2.2" from "1.1.1.1,2.2.2.2"
weave_peers_terraform_to_ansible() {
  local IFS=','
  local ips_string=$1
  local ips=( ${ips_string} )
  echo "${ips[@]}"
}

terraform_to_ansible() {
  pushd $APOLLO_ROOT/terraform/${APOLLO_PROVIDER}
  local ips=$(terraform output master_ips)
  export APOLLO_mesos_zk_url="$( mesos_zk_url_terraform_to_ansible ${ips} )"
  export APOLLO_weave_launch_peers="$( weave_peers_terraform_to_ansible ${ips} )"
  popd
}
