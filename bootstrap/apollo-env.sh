#!/bin/bash

# Set the default provider of Apollo cluster to know where to load provider-specific scripts
# You can override the default provider by exporting the APOLLO_PROVIDER
# variable in your bashrc
APOLLO_PROVIDER=${APOLLO_PROVIDER:-aws}
# change global log level of components, set APOLLO_LOG to any value to enable
APOLLO_LOG=${APOLLO_LOG:-}
ANSIBLE_LOG=${ANSIBLE_LOG:-}

# Overrides default folder in Terraform.py inventory.
export TF_VAR_STATE_ROOT="${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"

# Some useful colors.
if [[ -z "${color_start-}" ]]; then
  export color_start="\033["
  export color_red="${color_start}0;31m"
  export color_yellow="${color_start}0;33m"
  export color_green="${color_start}0;32m"
  export color_norm="${color_start}0m"
fi

# Change logging levels of called components at a global level
# if unset allow for existing selective logging of components
case "${APOLLO_LOG}" in
  "")
    # Do nothing in this instance
  ;;
  0)
    # Force minimal logging
    echo "Forcing reduction of component logging"
    export TF_LOG=
    export ANSIBLE_LOG=
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
