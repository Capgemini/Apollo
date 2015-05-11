#!/bin/bash

# Set the default provider of Apollo cluster to know where to load provider-specific scripts
# You can override the default provider by exporting the APOLLO_PROVIDER
# variable in your bashrc
APOLLO_PROVIDER=${APOLLO_PROVIDER:-aws}
# change global log level of components, set APOLLO_LOG to any value to enable
APOLLO_LOG=${APOLLO_LOG:-error}

# Some useful colors.
if [[ -z "${color_start-}" ]]; then
  declare -r color_start="\033["
  declare -r color_red="${color_start}0;31m"
  declare -r color_yellow="${color_start}0;33m"
  declare -r color_green="${color_start}0;32m"
  declare -r color_norm="${color_start}0m"
fi

# change logging levels of called components at a global level
# if unset allow for existing selective logging of components
case "${APOLLO_LOG}" in
  error)
    # Do nothing in this instance
  ;;
  0)
    # force minimal logging
    echo "Forcing reduction of component logging"
    unset TF_LOG
    unset ANSIBLE_LOG
  ;;
  1)
    export TF_LOG=1
    export ANSIBLE_LOG="-v"
  ;;
  *)
    export TF_LOG=${APOLLO_LOG}
    export ANSIBLE_LOG="-vvvv"

  ;;
esac
