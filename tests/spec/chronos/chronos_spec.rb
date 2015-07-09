require 'spec_helper'

describe docker_container('chronos') do
  it { should be_running }
end

describe port(4400) do
  it { should be_listening }
end

describe command('curl --silent --show-error --fail --dump-header /dev/stderr --retry 2 http://127.0.0.1:4400') do
  its(:exit_status) { should eq 0 }
  its(:stdout)      { should contain 'HTTP/1.1 200 OK' }
end

describe service('chronos') do
  it { should be_running }
end
