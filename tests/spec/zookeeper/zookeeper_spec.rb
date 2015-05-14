require 'spec_helper'

describe service('zookeeper') do
  it { should be_running }
end

describe port(2181) do
  it { should be_listening }
end

describe port(3888) do
  it { should be_listening }
end

describe file('/etc/zookeeper/conf/myid') do
  it            { should be_file }
  it            { should be_mode 644 }
  # Match 1-5 its unlikely we will be deploying > 5 node master cluster
  its(:content) { should match /^[1-5]$/ }
end

describe file('/etc/zookeeper/conf/zoo.cfg') do
  it            { should be_file }
  its(:content) { should match /dataDir=\/var\/lib\/zookeeper\// }
  its(:content) { should match /initLimit=5/ }
  its(:content) { should match /syncLimit=2/ }
  its(:content) { should match /^server.[1-5]=.*:2888:3888/ }
end
