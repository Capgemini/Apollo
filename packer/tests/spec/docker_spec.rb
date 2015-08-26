require 'spec_helper'

describe package('docker-engine') do
  it { should be_installed.by('apt').with_version(ENV['DOCKER_VERSION']) }
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
