require_relative 'spec_helper'

recipe = 'zookeeper::client'

describe recipe do
  let(:chef_run) {
    runner = ChefSpec::Runner.new()
    runner.converge recipe
  }

  it "should include the zookeeper recipe" do
    expect(chef_run).to include_recipe("zookeeper")
  end
 
end
