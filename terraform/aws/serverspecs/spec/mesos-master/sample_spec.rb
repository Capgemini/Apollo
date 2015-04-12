require 'spec_helper'

describe package('mesos') do
  it { should be_installed }
end

describe service('mesos') do
  it { should be_running }
end

