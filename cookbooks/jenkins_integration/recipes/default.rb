#
# Cookbook Name:: jenkins_integration
# Recipe:: default
#
# Copyright 2012, Infochimps, Inc.
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

# Ensure .ssh directory exists
ssh_dir                 = node[:jenkins][:server][:home_dir] + '/.ssh'
directory ssh_dir do
  owner         node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
  mode          '0700'
end

# Set up the correct public key
private_key_filename     = ssh_dir + '/id_rsa'
file private_key_filename do
  owner         node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
  content       node[:jenkins_integration][:deploy_key]
  mode          '0600'
  notifies      :run, 'execute[Regenerate id_rsa.pub]', :immediately
end
execute 'Regenerate id_rsa.pub' do
  user          node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
  cwd           ssh_dir
  command       "ssh-keygen -y -f id_rsa -N'' -P'' > id_rsa.pub"
  action        :nothing
end

# Add Github's fingerprint to known_hosts
cookbook_file ssh_dir + '/github.fingerprint' do
  user          node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
  notifies      :run, 'execute[Get familiar with Github]', :immediately
end
execute 'Get familiar with Github' do
  user          node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
  cwd           ssh_dir
  command       "cat github.fingerprint >> known_hosts"
  action        :nothing
end

# Setup jenkins user to make commits
template node[:jenkins][:server][:home_dir] + '/.gitconfig' do
  source        '.gitconfig.erb'
  owner         node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
end

# Lock access down to local user accounts
# FIXME: This is only the vaguest of security, very unconfigurable,
#   and really should be done over HTTPS to prevent pw hash sniffing.
if node[:jenkins_integration][:security] == "local_users"
  group "shadow" do
    action :modify
    members node[:jenkins][:server][:user]
    append true
  end

  template "#{node[:jenkins][:server][:home_dir]}/config.xml" do
    source        "core.config.xml.erb"
    
    variables({ :addl_permissions => node[:jenkins_integration][:addl_permissions],
                :addl_views => node[:jenkins_integration][:addl_views] })

    owner         node[:jenkins][:server][:user]
    group         node[:jenkins][:server][:group]
  end
end

# FIXME: fucking omnibus
file node[:jenkins][:server][:home_dir] + '/.profile' do
  content       'export PATH=/opt/chef/embedded/bin/:$PATH'
  owner         node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
end

# FIXME: This should be another recipe
execute "set timezone" do
  command <<-eof
    echo 'US/Central' > /etc/timezone
    dpkg-reconfigure --frontend noninteractive tzdata
  eof
end

# `git up` syncs all local branches with remotes
gem_package 'git-up'
