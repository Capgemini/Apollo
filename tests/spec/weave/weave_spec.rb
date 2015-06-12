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
  it { should be_mode 644 }
end

describe docker_container('weave') do
  it { should be_running }
end

describe docker_container('weavescope') do
  it { should be_running }
end

describe file('/etc/init/weave.conf') do
  it { should be_file }
  it { should be_mode 755 }
end

describe file('/etc/init/weavescope.conf') do
  it { should be_file }
  it { should be_mode 755 }
end

describe file('/etc/default/docker') do
  it            { should be_file }
  its(:content) { should match /--bridge=weave/ }
end
