require 'chefspec'

recipe = 'zookeeper::client'

describe recipe do
  let(:chef_run) {
    runner = ChefSpec::ChefRunner.new()
    runner.converge recipe
  }

  it "should include the zookeeper recipe" do
    expect(chef_run).to include_recipe "zookeeper"
  end
 
end
