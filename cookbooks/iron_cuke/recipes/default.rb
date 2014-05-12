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
  reference node['iron_cuke']['git_branch']
end

file "#{node['iron_cuke']['conf_dir']}/announces.json" do
  content({"#{node.name}" => node[:announces].to_hash }.to_json)
end

if platform_family?('rhel')
  package "xorg-x11-server-Xvfb"
elsif platform_family?('debian')
  package "libqtwebkit-dev"
  package "xvfb"
end

execute "bundle install --without development test docs support" do
  cwd node['iron_cuke']['home_dir']
end

# Q: Why aren't we being idempotent?
# A: Because the timestamps in the announcements change with each Chef run
execute "bundle exec bin/iron_cuke gen_tests -a #{node['iron_cuke']['conf_dir']}/announces.json" do
  cwd node['iron_cuke']['home_dir']
end
