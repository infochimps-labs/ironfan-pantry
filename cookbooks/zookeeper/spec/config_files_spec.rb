require_relative 'spec_helper'

recipe = 'zookeeper::config_files'

describe recipe do
  it 'creates zookeeper configuration' do

    # Server stubs for discovery
    srv0 = double("srv", :node => { :zookeeper => { :zkid => 0 }, :ipaddress => '10.10.0.1' }) 
    srv1 = double("srv", :node => { :zookeeper => { :zkid => 1 }, :ipaddress => '10.10.0.2' }) 
    srv2 = double("srv", :node => { :zookeeper => { :zkid => 2 }, :ipaddress => '10.10.0.3' }) 

    Chef::Recipe.any_instance.stub(:discover_all).with(:zookeeper, :server).and_return([srv0, srv1, srv2])
    chef_run = ChefSpec::Runner.new()
    chef_run.converge recipe 
  end
end
