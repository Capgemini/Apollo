#!/bin/bash
set -e
source ../common.sh

RED='\033[0;31m'
NC='\033[0m'

test() {
  function="$1"
  expected="$2"
  input="$3"

  result=$( "${function}" "${input}" )
  [ $? -eq 0 ] || echo "Script failed."

  if [ "${result}" == "${expected}" ]; then
    echo "Pass. Function ${function}. Expected: ${expected}, Got: ${result}"
  else
    echo "${RED}Fail. Function ${function}. Expected: ${expected}, Got: ${result}${NC}"
  fi	
}

function="mesos_zk_url_terraform_to_ansible"
expected="zk://1.1.1.1:2181,2.2.2.2:2181,3.3.3.3:2181/mesos"
input="1.1.1.1,2.2.2.2,3.3.3.3"
test "${function}" "${expected}" "${input}"

function="weave_peers_terraform_to_ansible"
expected="1.1.1.1 2.2.2.2 3.3.3.3"
input="1.1.1.1,2.2.2.2,3.3.3.3"
test "${function}" "${expected}" "${input}"

export TESTSUITE_var1="Galicia"
export TESTSUITE_var2="Drupal"
export TESTSUITE_var3="ip1 ip2 ip3"
function="get_apollo_variables"
input="TESTSUITE_"
expected="var2='Drupal' var3='ip1 ip2 ip3' var1='Galicia'"
test "${function}" "${expected}" "${input}"