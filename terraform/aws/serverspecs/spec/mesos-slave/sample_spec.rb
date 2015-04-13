require 'spec_helper'

describe package('mesos') do
  it { should be_installed }
end

describe service('mesos-slave') do
  it { should be_running }
end

describe service('consul') do
  it { should be_running }
end

describe service('docker') do
  it { should be_running }
end

describe service('dnsmasq') do
  it { should be_running }
end

describe port(53) do
  it { should be_listening }
end

describe bridge('weave') do
  it { should exist }
end