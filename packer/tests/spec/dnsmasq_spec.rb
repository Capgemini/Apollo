require 'spec_helper'

describe package('dnsmasq') do
  it { should be_installed }
end

describe service('dnsmasq') do
  it { should_not be_running }
end

describe file('/etc/init/dnsmasq.override') do
  it { should be_file }
end
