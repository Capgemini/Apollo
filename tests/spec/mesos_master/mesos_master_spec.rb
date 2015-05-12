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
