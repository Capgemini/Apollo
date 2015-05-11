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
  local version_string=`terraform --version | awk '{print $2}'`
  local -a current_version=( ${version_string#'v'} )
  local -a version_requirement=( ${1:-0.5.0} )
  local n diff

  for (( n=0; n<${#version_requirement[@]}; n+=1 )); do
    diff=$((current_version[n]-version_requirement[n]))
    if [ $diff -ne 0 ] ; then
      [ $diff -le 0 ] && echo -1 || echo 0
      return
    fi
  done
  echo 0
}
