#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

APOLLO_ROOT=$(dirname "${BASH_SOURCE}")/..
source "${APOLLO_ROOT}/bootstrap/apollo-env.sh"
source "${APOLLO_ROOT}/bootstrap/common.sh"
source "${APOLLO_ROOT}/bootstrap/${APOLLO_PROVIDER}/util.sh"

main() {
  echo "Starting cluster using provider: $APOLLO_PROVIDER" >&2

  echo "... calling verify-prereqs" >&2
  verify_prereqs

  echo "... calling apollo-launch" >&2
  apollo_launch $@
}

main $@
exit 0
