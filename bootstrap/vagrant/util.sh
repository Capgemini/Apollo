#!/bin/bash

# Use the config file specified in $APOLLO_CONFIG_FILE, or default to
# config-default.sh.
APOLLO_ROOT=$(dirname "${BASH_SOURCE}")/../..

verify_prereqs() {
  if [[ "$(which vagrant)" == "" ]]; then
    echo -e "${color_red}Can't find vagrant in PATH, please fix and retry.${color_norm}"
    exit 1
  fi
}

apollo_launch() {
  install_contributed_roles
  vagrant up --provision
  open_urls
}

apollo_down() {
  vagrant destroy -f
}
