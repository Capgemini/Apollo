require 'spec_helper'

describe package('mesos') do
  it { should be_installed }
end

describe service('mesos-master') do
  it { should be_running }
end

describe port(5050) do
  it { should be_listening }
end

describe package('marathon') do
  it { should be_installed }
end

describe service('marathon') do
  it { should be_running }
end

describe port(8080) do
  it { should be_listening }
end

describe service('consul') do
  it { should be_running }
end

describe service('zookeeper') do
  it { should be_running }
end

describe port(2181) do
  it { should be_listening }
end

describe service('dnsmasq') do
  it { should be_running }
end

describe port(53) do
  it { should be_listening }
end