require 'spec_helper'

describe service('networking') do
  it { should be_running }
end

describe bridge('weave') do
  it { should exist }
end

describe docker_container('weave') do
  it { should be_running }
end

describe file('/etc/init/weave.conf') do
  it { should be_file }
  it { should be_mode 755 }
end


