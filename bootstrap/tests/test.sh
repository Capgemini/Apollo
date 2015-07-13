#!/bin/bash

source ../common.sh

RED='\033[0;31m'
NC='\033[0m'

test() {
  function="$1"
  expected="$2"
  input="$3"

  result=$( "${function}" "${input}" )
  [ $? -eq 0 ] || echo "Function ${function} returned exit code 0."

  if [ "${result}" == "${expected}" ]; then
    echo "Pass. Function ${function}. Expected: ${expected}, Got: ${result}"
  else
    echo "${RED}Fail. Function ${function}. Expected: ${expected}, Got: ${result}${NC}"
  fi
}

function="check_terraform_version"
expected="You are running Terraform v0.5.0..."
input="0.5.0"
test "${function}" "${expected}" "${input}"

function="check_terraform_version"
expected="You are running Terraform v0.5.0...
-e Terraform >= 0.7.0 is required, please fix and retry."
input="0.7.0"
test "${function}" "${expected}" "${input}"

export TESTSUITE_var1="Galicia"
export TESTSUITE_var2="Drupal"
export TESTSUITE_var3="ip1 ip2 ip3"
export TESTSUITE_var4="property=val property=val property=val"
function="get_apollo_variables"
input="TESTSUITE_"
expected="var4='property=val property=val property=val' var2='Drupal' var3='ip1 ip2 ip3' var1='Galicia'"
test "${function}" "${expected}" "${input}"

# Network identifier helper function tests.
function="get_network_identifier"
expected="10"
input="10.0.0.0/16"
test "${function}" "${expected}" "${input}"

function="get_network_identifier"
expected="172"
input="172.31.1.0/24"
test "${function}" "${expected}" "${input}"
