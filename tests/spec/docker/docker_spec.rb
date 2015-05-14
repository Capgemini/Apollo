require 'spec_helper'

describe service('docker') do
  it { should be_running }
end

descibe file('/etc/init/docker.override') do
  it { should_not be_file }
end
