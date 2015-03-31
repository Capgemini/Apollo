#!/usr/bin/env bash
set -eux
set -o pipefail

sudo wget -O /usr/local/bin/weave \
    https://github.com/zettio/weave/releases/download/${WEAVE_VERSION}/weave
sudo chmod a+x /usr/local/bin/weave

