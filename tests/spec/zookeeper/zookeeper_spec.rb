require 'spec_helper'

describe service('zookeeper') do
  it { should be_running }
end

describe port(2181) do
  it { should be_listening }
end
