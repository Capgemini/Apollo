require 'spec_helper'

describe package('mesos') do
  it { should be_installed }
end

describe service('mesos-slave') do
  it { should be_running }
end
