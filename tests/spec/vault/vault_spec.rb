require 'spec_helper'

describe port(8200) do
  it { should be_listening }
end

describe service('vault') do
  it { should be_running }
end

describe command("curl -L -k http://localhost:8200/v1/sys/init") do
  its(:stdout) { should match '{\"initialized\":true}\n' }
  its(:exit_status) { should eq 0 }
end

describe command("curl -L -k http://localhost:8200/v1/sys/seal-status") do
  its(:stdout) { should match '{\"sealed\":false,\"t\":3,\"n\":5,\"progress\":0}\n' }
  its(:exit_status) { should eq 0 }
end
