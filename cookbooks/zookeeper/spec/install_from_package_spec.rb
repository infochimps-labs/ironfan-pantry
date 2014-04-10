require_relative 'spec_helper'

describe 'zookeeper::install_from_package' do
  let (:chef_run) { ChefSpec::Runner.new.converge('zookeeper::install_from_package') }

  it "installs hadoop-zookeeper" do
    expect(chef_run).to install_package('hadoop-zookeeper')
  end

end
