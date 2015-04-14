#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

APOLLO_ROOT=$(dirname "${BASH_SOURCE}")/..
source "${APOLLO_ROOT}/cluster/apollo-env.sh"
source "${APOLLO_ROOT}/cluster/${APOLLO_PROVIDER}/util.sh"

echo "Bringing down cluster using provider: $APOLLO_PROVIDER"

verify_prereqs
apollo_down

echo "Done"
