require 'spec_helper'

describe docker_container('traefik') do
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end
