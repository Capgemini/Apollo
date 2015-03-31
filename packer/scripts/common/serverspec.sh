#!/usr/bin/env bash
set -eux
set -o pipefail

sudo gem install bundler --no-ri --no-rdoc
cd /tmp/tests
bundle install --path=vendor
bundle exec rake spec
