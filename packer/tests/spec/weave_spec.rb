require 'spec_helper'

describe file('/usr/local/bin/weave') do
  it { should be_file }
end
