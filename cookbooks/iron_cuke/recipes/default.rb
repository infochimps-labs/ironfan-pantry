#
# Cookbook Name:: iron_cuke
# Recipe:: default
#
#standard_dirs('iron_cuke') do
#  directories [:conf_dir]
#end

include_recipe 'silverware'
package "git"

announce(:flume, :agent, {
    :ports   => {
      :status => { :port => 35862, :protocol => 'http', :dashboard => true }  },
    :daemons => {
      :java => { :name => 'java', :cmd => 'FlumeNode' } },
  })

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
  action :checkout
end

file "#{node['iron_cuke']['conf_dir']}/announces.json" do
  content({"#{node.name}" => node[:announces].to_hash }.to_json)
end

execute "bundle install" do
  cwd node['iron_cuke']['home_dir']
end

# Q: Why aren't we being idempotent?
# A: Because the timestamps in the announcements change with each Chef run
execute "bundle exec bin/iron_cuke gen_tests -a #{node['iron_cuke']['conf_dir']}/announces.json" do
  cwd node['iron_cuke']['home_dir']
end
