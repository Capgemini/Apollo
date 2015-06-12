#!/bin/bash

# Set the default provider of Apollo cluster to know where to load provider-specific scripts
# You can override the default provider by exporting the APOLLO_PROVIDER
# variable in your bashrc
APOLLO_PROVIDER=${APOLLO_PROVIDER:-aws}

# Some useful colors.
if [[ -z "${color_start-}" ]]; then
  export color_start="\033["
  export color_red="${color_start}0;31m"
  export color_yellow="${color_start}0;33m"
  export color_green="${color_start}0;32m"
  export color_norm="${color_start}0m"
fi

