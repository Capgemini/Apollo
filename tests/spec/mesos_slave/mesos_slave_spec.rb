require 'spec_helper'

describe package('mesos') do
  it { should be_installed }
end

describe "mesos slave" do
  describe service('mesos-slave') do
    it { should be_running }
  end

  describe file('/etc/mesos/zk') do
    it            { should be_file }
    its(:content) { should contain ':2181/mesos' }
  end

  describe file('/etc/default/mesos-slave') do
    it            { should be_file }
    its(:content) { should match /^MASTER=`cat \/etc\/mesos\/zk`$/ }
  end

  describe file('/etc/mesos-slave') do
    it { should be_directory }
  end
  describe file('/etc/mesos-slave/work_dir') do
    it            { should be_file }
  end
end

describe "mesos master" do
  describe service('mesos-master') do
    it { should_not be_running }
  end
end
