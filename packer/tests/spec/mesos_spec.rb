require 'spec_helper'

describe package('mesos') do
  it { should be_installed }
end

describe package('zookeeper') do
  it { should be_installed }
end


services = [
  'mesos-master',
  'mesos-slave',
  'zookeeper'
]

services.each do |service|
  describe service(service) do
    it { should be_installed }
    it { should_not be_running }
  end
end

service_files = [
  '/etc/init/mesos-master.override',
  '/etc/init/mesos-slave.override',
  '/etc/init/zookeeper.override',
]

service_files.each do |file|
  describe file(file) do
    it { should be_file }
  end
end

descibe file('/etc/mesos-slave/containerizers') do
  it { should be_file }
  its(:content) { should match /docker,mesos/ }
end

descibe file('/etc/mesos-slave/executor_registration_timeout') do
  it { should be_file }
  its(:content) { should match /10mins/ }
end
