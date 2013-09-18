#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2008-2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

include_recipe "mysql::client"

if node[:platform_family] == 'debian'

  directory "/var/cache/local/preseeding" do
    owner "root"
    group node['mysql']['root_group']
    mode 0755
    recursive true
  end

  execute "preseed mysql-server" do
    command "debconf-set-selections /var/cache/local/preseeding/mysql-server.seed"
    action :nothing
  end

  template "/var/cache/local/preseeding/mysql-server.seed" do
    source "mysql-server.seed.erb"
    owner "root"
    group node['mysql']['root_group']
    mode "0600"
    notifies :run, resources(:execute => "preseed mysql-server"), :immediately
  end

  template "#{node['mysql']['conf_dir']}/mysql/debian.cnf" do
    source "debian.cnf.erb"
    owner "root"
    group node['mysql']['root_group']
    mode "0600"
  end

end

package node['mysql']['package_name'] do
  action :install
end

if node[:platform_family] == 'debian'
  directory "#{node['mysql']['conf_dir']}/mysql/conf.d" do
    owner "mysql"
    group "mysql"
    action :create
    recursive true
  end
else
  directory "#{node['mysql']['conf_dir']}/mysql/conf.d" do
    owner "mysql"
    group "mysql"
    action :create
    recursive true
  end
end

service "mysql" do
  service_name node['mysql']['service_name']
  if (node[:platform_family] == "debian" && node.platform_version.to_f >= 10.04)
    restart_command "restart mysql"
    stop_command "stop mysql"
    start_command "start mysql"
  end
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

skip_federated = case node[:platform_family]
                 when 'debian'
                   true
                 when 'rhel'
                   node['platform_version'].to_f < 6.0
                 else
                   false
                 end

template "#{node['mysql']['conf_dir']}/mysql/my.cnf" do
  source "my.cnf.erb"
  owner "root"
  group node['mysql']['root_group']
  mode "0644"
  notifies :restart, resources(:service => "mysql"), :immediately
  variables :skip_federated => skip_federated
end

unless Chef::Config[:solo]
  ruby_block "save node data" do
    block do
      node.save
    end
    action :create
  end
end

# set the root password on platforms 
# that don't support pre-seeding
unless node[:platform_family] == 'debian'

  execute "assign-root-password" do
    command "#{node['mysql']['mysqladmin_bin']} -u root password \"#{node['mysql']['server_root_password']}\""
    action :run
    only_if "#{node['mysql']['mysql_bin']} -u root -e 'show databases;'"
  end

end

grants_path = node['mysql']['grants_path']

begin
  t = resources("template[#{grants_path}]")
rescue
  Chef::Log.info("Could not find previously defined grants.sql resource")
  t = template grants_path do
    source "grants.sql.erb"
    owner "root"
    group node['mysql']['root_group']
    mode "0600"
    action :create
  end
end

execute "mysql-install-privileges" do
  command "#{node['mysql']['mysql_bin']} -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p' }\"#{node['mysql']['server_root_password']}\" < #{grants_path}"
  action :nothing
  subscribes :run, resources("template[#{grants_path}]"), :immediately
end

# NOTE: added by Josh 23 Aug 2013. This ensures that the data
# directory is accessible by mysql.
directory node['mysql']['data_dir'] do
  owner "mysql"
  group "mysql"
  mode 0700
  action :create
end

announce(:mysql, :server, {
           :logs => { 
             :mysql => {
               :glob => '/var/log/mysql/*.log'
             } 
           },
           :ports => {
             :mysql => {
               :port => 3306
             } 
           },
           :daemons => {
             :mysql => {
               :name => 'mysqld',
               :user => 'mysql'
             }
           }
         })
