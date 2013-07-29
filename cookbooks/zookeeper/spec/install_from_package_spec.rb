require 'chefspec'

describe 'zookeeper::install_from_package' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'zookeeper::install_from_package' }

  it "includes hadoop_cluster::add_cloudera_repo" do
    expect(chef_run).to include_recipe "hadoop_cluster::add_cloudera_repo"
  end

  it "installs hadoop-zookeeper" do
    expect(chef_run).to install_package 'hadoop-zookeeper'
  end

end
