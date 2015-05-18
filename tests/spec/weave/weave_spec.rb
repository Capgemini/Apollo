require 'spec_helper'

describe service('networking') do
  it { should be_running }
end

describe bridge('weave') do
  it { should exist }
end

describe file('/etc/network/interfaces') do
  it            { should be_file }
  its(:content) { should match /source \/etc\/network\/interfaces.d\/\*\.cfg/ }
end

describe file('/etc/network/interfaces.d/weave.cfg') do
  it            { should be_file }
  its(:content) { should match /iface weave inet manual/ }
end

describe docker_container('weave') do
  it { should be_running }
end
