require 'spec_helper'

describe package('docker-py') do
  it { should be_installed.by('pip').with_version('1.3.0') }
end

describe package('lxc-docker') do
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
