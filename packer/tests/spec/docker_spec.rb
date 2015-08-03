require 'spec_helper'

docker_version = 'lxc-docker-' + ENV['DOCKER_VERSION']

describe package(docker_version) do
  it { should be_installed }
end

describe package("linux-image-extra-#{`uname -r`.strip}") do
  it { should be_installed }
end

describe service('docker') do
  it { should_not be_running }
end

describe file('/etc/init/docker.override') do
  it { should be_file }
end
