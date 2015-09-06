require 'spec_helper'

describe docker_container('mesos-slave') do
  it { should be_running }
  # it { should have_volume('/tmp/mesos','/tmp/mesos') }
end

describe "mesos slave" do
  describe service('mesos-slave') do
    it { should be_running }
  end
end

describe "mesos slave" do
  describe service('mesos-master') do
    it { should_not be_running }
  end
end

describe port(5051) do
  it { should be_listening }
end
