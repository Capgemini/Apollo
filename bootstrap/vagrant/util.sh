#!/bin/bash

# Use the config file specified in $APOLLO_CONFIG_FILE, or default to
# config-default.sh.
APOLLO_ROOT=$(dirname "${BASH_SOURCE}")/../..
source "${APOLLO_ROOT}/bootstrap/vagrant/${APOLLO_CONFIG_FILE-"config-default.sh"}"

verify_prereqs() {
  if [[ "$(which vagrant)" == "" ]]; then
    echo -e "${color_red}Can't find vagrant in PATH, please fix and retry.${color_norm}"
    exit 1
  fi
}

apollo_launch() {
  get_ansible_requirements
  vagrant up --provision
}

apollo_down() {
  vagrant destroy -f
}
