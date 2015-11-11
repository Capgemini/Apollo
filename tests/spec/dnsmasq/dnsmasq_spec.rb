require 'spec_helper'

describe service('dnsmasq') do
  it { should be_running }
end

describe file('/etc/dnsmasq.d/10-consul') do
  it { should be_file }
  it { should contain 'server=/consul/.*#8600' }
end

describe docker_container('dnsmasq') do
  it { should be_running }
  # it { should have_volume('/etc/dnsmasq.d','/etc/dnsmasq.d') }
end

describe port(53) do
  it { should be_listening }
end

# Containers should be able to reach each other
# via dnsmasq resolving through consul-dns.
describe command("docker exec cadvisor ping -c 3 marathon") do
  its(:exit_status) { should eq 0 }
end
