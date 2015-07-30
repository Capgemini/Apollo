describe docker_container('mesos-master') do
  it { should be_running }
end

describe "mesos master" do
  describe service('mesos-master') do
    it { should_not be_running }
  end
end
