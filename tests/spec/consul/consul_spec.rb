require 'spec_helper'

describe service('consul') do
  it { should be_running }
end

describe file('/etc/init/consul.override') do
  it { should_not be_file }
end

describe port(8301) do
  it { should be_listening }
end

describe port(8400) do
  it { should be_listening }
end

describe port(8600) do
  it { should be_listening }
end

describe file('/etc/consul.d/consul.json') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end
