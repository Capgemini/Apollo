require 'spec_helper'

describe service('docker') do
  it { should be_running }
end
