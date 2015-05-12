require 'spec_helper'

describe service('consul') do
  it { should be_running }
end
