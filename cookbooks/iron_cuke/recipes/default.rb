#
# Cookbook Name:: iron_cuke
# Recipe:: default
#

directory node['iron_cuke']['conf_dir'] do
  owner node['iron_cuke']['user']
  group node['iron_cuke']['group']
  mode 0755
end

git node['iron_cuke']['home_dir'] do
  repository node['iron_cuke']['git_repo']
  reference "master"
  action :checkout
end

file "#{node['iron_cuke']['conf_dir']}/announces.json" do
  content node['announces'].to_json
  owner node['iron_cuke']['user']
  group node['iron_cuke']['group']
end

execute "bundle install" do
  cwd node['iron_cuke']['home_dir']
end

execute "bundle exec bin/ironcuke gen_tests -a #{node['iron_cuke']['conf_dir']}/announces.json" do
  cwd node['iron_cuke']['home_dir']
end

execute "bundle exec bin/ironcuke judge" do
  cwd node['iron_cuke']['home_dir']
end
