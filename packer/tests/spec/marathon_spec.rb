require 'spec_helper'

describe package('marathon') do
  it { should be_installed }
end

describe service('marathon') do
  it { should be_installed }
  it { should_not be_running }
end

describe file('/etc/init/marathon.override') do
  it { should be_file }
end

describe file('/etc/marathon/conf/task_launch_timeout') do
  it { should be_file }
  its(:content) { should match /300000/ }
end
