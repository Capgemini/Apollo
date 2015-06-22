require 'spec_helper'

describe docker_container('registrator') do
  it { should be_running }
  it { should have_volume('/tmp/docker.sock','/var/run/docker.sock') }
end
