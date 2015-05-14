require 'spec_helper'

describe package('mesos') do
  it { should be_installed }
end

describe "mesos master" do
  describe service('mesos-master') do
    it { should be_running }
  end

  describe command("curl --silent --show-error --fail --dump-header /dev/stderr --retry 2 http://#{host_inventory['hostname']}:5050/master/health") do
    its(:stdout)  { should match /HTTP\/1.1 200 OK/ }
  end
  describe file('/var/lib/mesos') do
    it { should be_directory }
  end

  describe file('/etc/mesos-master') do
    it { should be_directory }

    describe file('/etc/mesos-master/ip') do
      it { should be_file }
    end

    describe file('/etc/mesos-master/quorum') do
      it            { should be_file }
      its(:content) { should contain '1' }
    end
  end

  describe file('/etc/mesos/zk') do
    it            { should be_file }
    its(:content) { should contain(':2181/mesos') }
  end

  describe file('/etc/default/mesos') do
    it            { should be_file }
    its(:content) { should match /^LOGS=\/var\/log\/mesos/ }
    its(:content) { should match /^ULIMIT="-n 8192"$/ }
  end
  describe file('/etc/default/mesos-master') do
    its(:content) { should match /^PORT=5050/ }
    its(:content) { should match /^ZK=`cat \/etc\/mesos\/zk`/ }
  end

  describe port(5050) do
    it { should be_listening }
  end
end

describe "mesos slave" do
  describe service('mesos-slave') do
    it { should_not be_running }
  end
end
