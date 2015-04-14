#!/bin/bash

# Set the default provider of Apollo cluster to know where to load provider-specific scripts
# You can override the default provider by exporting the APOLLO_PROVIDER
# variable in your bashrc
APOLLO_PROVIDER=${APOLLO_PROVIDER:-aws}

# Some useful colors.
if [[ -z "${color_start-}" ]]; then
  declare -r color_start="\033["
  declare -r color_red="${color_start}0;31m"
  declare -r color_yellow="${color_start}0;33m"
  declare -r color_green="${color_start}0;32m"
  declare -r color_norm="${color_start}0m"
fi

