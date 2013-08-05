require 'minitest/spec'

describe_recipe 'zookeeper::config_files' do

  describe 'files' do 
    it "configures zookeeper correctly" do
      %w[ zoo.cfg log4j.properties ].each do |conf_file|
        file("/etc/zookeeper/#{conf_file}").must_have(:owner, "root").and(:mode, "0644")
      end
    end
  end

  describe 'services' do 
    it "runs as a zookeeper" do
      service("zookeeper").must_be_running
    end
  end  

end
