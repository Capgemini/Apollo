require 'spec_helper'

describe docker_container('mesos-slave') do
  it { should be_running }
end

describe "mesos slave" do
  describe service('mesos-slave') do
    it { should be_running }
  end

describe "mesos master" do
  describe service('mesos-master') do
    it { should_not be_running }
  end
end
