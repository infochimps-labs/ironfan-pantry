#
# Cookbook Name:: iron_cuke
# Recipe:: default
#
#standard_dirs('iron_cuke') do
#  directories [:conf_dir]
#end

include_recipe 'silverware'
package "git"

directory node['iron_cuke']['conf_dir'] do
  owner node['iron_cuke']['user']
  group node['iron_cuke']['group']
  mode 0755
end

directory node['iron_cuke']['home_dir'] do
  owner node['iron_cuke']['user']
  group node['iron_cuke']['group']
  mode 0755
end

git node['iron_cuke']['home_dir'] do
  repository node['iron_cuke']['git_repo']
  reference "master"
end

file "#{node['iron_cuke']['conf_dir']}/announces.json" do
  content({"#{node.name}" => node[:announces].to_hash }.to_json)
end
