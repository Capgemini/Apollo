require 'spec_helper'

packages = [
  'git',
  'curl',
  'libcurl3',
  'oracle-java8-installer',
  'unzip',
  'wget',
  'python-setuptools',
  'python-protobuf',
  'cgroup-bin'
]

packages.each do |package|
  describe package(package) do
    it { should be_installed }
  end
end
