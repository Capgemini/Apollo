require 'spec_helper'

describe docker_container('cadvisor') do
  it { should be_running }
  # it { should have_volume('/var/lib/docker','/var/lib/docker') }
  # it { should have_volume('/rootfs','/') }
  # it { should have_volume('/var/run','/var/run') }
  # it { should have_volume('/sys','/sys') }
end

describe port(8081) do
  it { should be_listening }
end

describe service('cadvisor') do
  it { should be_running }
end
