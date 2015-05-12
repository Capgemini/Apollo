require 'spec_helper'

describe docker_container('haproxy') do
  it { should be_running }
end
