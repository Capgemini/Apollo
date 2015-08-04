describe docker_container('mesos-master') do
  it { should be_running }
  it { should have_volume('/var/lib/mesos','/var/lib/mesos') }
end

describe "mesos master" do
  describe service('mesos-slave') do
    it { should_not be_running }
  end
end

describe port(5050) do
  it { should be_listening }
end
