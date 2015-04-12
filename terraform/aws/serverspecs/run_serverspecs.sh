#!/bin/bash
SPECS_SUITE=$1
SPECS_PATH={$2:-/tmp/serverspecs}
pushd ${SPECS_PATH}
# This can be removed once we rebuild the base image with bundler installed. 
sudo apt-get -y install bundler
bundle install --path=vendor && bundle exec rake spec:${SPECS_SUITE}
popd