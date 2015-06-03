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