require 'spec_helper'

describe 'consul' do


  describe service('consul') do
    it { should be_running }
  end

  describe file('/etc/init/consul.override') do
    it { should_not be_file }
  end

  describe port(8301) do
    it { should be_listening }
  end

  describe port(8400) do
    it { should be_listening }
  end
  describe port(8500) do
    it { should be_listening }
  end
  describe command('curl --silent --show-error --fail --dump-header /dev/stderr --retry 2 http://127.0.0.1:8500/v1/catalog/service/consul') do
    its(:exit_status) { should eq 0 }
    its(:stdout)      { should contain 'HTTP/1.1 200 OK' }
    its(:stdout)      { should contain 'X-Consul-Knownleader: true' }
  end

  describe port(8600) do
    it { should be_listening }
  end

  describe file('/etc/consul.d/consul.json') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end
