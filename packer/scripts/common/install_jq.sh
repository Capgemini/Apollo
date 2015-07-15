#!/usr/bin/env bash
set -eu
set -o pipefail

sudo curl http://stedolan.github.io/jq/download/linux64/jq -o /usr/local/bin/jq
sudo chmod +x /usr/local/bin/jq
