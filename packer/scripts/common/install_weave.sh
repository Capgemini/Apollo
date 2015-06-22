#!/usr/bin/env bash
set -eux
set -o pipefail

sudo wget -O /usr/local/bin/weave \
    https://github.com/weaveworks/weave/releases/download/v${WEAVE_VERSION}/weave
sudo chmod a+x /usr/local/bin/weave

