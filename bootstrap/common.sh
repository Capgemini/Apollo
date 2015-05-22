#!/bin/bash

# Util functions cloud reusable.

get_apollo_variables() {
  local plugin_namespace='APOLLO_'
  local var_list=()
  for i in $(env | grep ${plugin_namespace}); do
  	# This deletes shortest match of $substring from front of $string. ${string#substring}
    var=${i#${plugin_namespace}}
    var_list+=(-var "$var")
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
  pushd $APOLLO_ROOT/terraform/${APOLLO_PTOVIDER}
    if [ -a /usr/bin/open ]; then
      /usr/bin/open "http://$(terraform output master.1.ip):5050"
      /usr/bin/open "http://$(terraform output master.1.ip):8080"
      /usr/bin/open "http://$(terraform output master.1.ip):8500"
    fi
  popd
}
