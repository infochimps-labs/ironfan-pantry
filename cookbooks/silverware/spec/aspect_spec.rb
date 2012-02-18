require File.expand_path('spec_helper', File.dirname(__FILE__))
require SILVERWARE_DIR("libraries/silverware")
require SILVERWARE_DIR("libraries/aspects")

describe Ironfan::Aspect do
  include_context 'dummy_chef'

  let(:foo_aspect){ Class.new(Ironfan::Aspect){ def self.handle() :foo end } }
  after(:each) do
    Ironfan::Component.keys.delete(:foos)
    Ironfan::Component.aspect_types.delete(:foos)
  end

  it 'knows its handle' do
    foo_aspect.handle.should == :foo
  end

  context 'register!' do
    it 'shows up in the Component.aspect_types' do
      Ironfan::Component.aspect_types.should_not include(foo_aspect)
      foo_aspect.register!
      Ironfan::Component.aspect_types[:foos].should == foo_aspect
    end

    it 'means it is called when a Component#harvest_all aspects' do
      foo_aspect.register!
      rc = Chef::RunContext.new(Chef::Node.new, [])
      foo_aspect.should_receive(:harvest).with(rc, chef_server_component)
      chef_server_component.harvest_all(rc)
    end
  end

end
