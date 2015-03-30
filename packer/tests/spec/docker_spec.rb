require 'spec_helper'

describe package('lxc-docker') do
  it { should be_installed }
end

describe service('docker') do
  it { should_not be_running }
end

describe file('/etc/init/docker.override') do
  it { should be_file }
end
