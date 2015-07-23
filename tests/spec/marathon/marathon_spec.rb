require 'spec_helper'

describe docker_container('marathon') do
  it { should be_running }
  it { should have_volume('/tmp/docker.sock','/var/run/docker.sock') }
  it { should have_volume('/store','/etc/marathon/store') }
end

describe port(8080) do
  it { should be_listening }
end

describe command("/usr/local/bin/marathon-wait-for-listen.sh") do
  its(:exit_status) { should eq 0 }
end

describe port(8080) do
  it { should be_listening }
end

describe service('marathon') do
  it { should be_running.under('upstart') }
end

describe command("curl -s -XPOST 127.0.0.1:8080/v2/apps -d@spec/marathon/sample.json -H \"Content-Type: application/json\" && sleep 5") do
  its(:exit_status) { should eq 0 }
end

describe command("curl -s 127.0.0.1:8080/v2/apps/serverspecs-app") do
  its(:stdout) { should match '.*"id":"/serverspecs-app".*' }
  its(:stdout) { should match '.*"tasksRunning":1.*' }
  its(:exit_status) { should eq 0 }
end
