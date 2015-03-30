require 'spec_helper'

describe file('/usr/bin/consul') do
  it { should be_file }
end

describe file('/etc/consul.d') do
  it { should be_directory }
  it { should be_mode 777 }
end

describe file('/etc/init/consul.conf') do
  it { should be_file }
end

describe file('/opt/consul-ui') do
  it { should be_directory }
end
