#
# Cookbook Name:: jenkins_integration
# Recipe:: ironfan_ci
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
  content       node[:jenkins_integration][:ironfan_ci][:deploy_key]
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

# Remove the indentation of multiline heredoc formatted strings.
# (Hackity hack, don't talk back.)
module Ironfan
  def self.reformat_heredoc(string='')
    depth = string.gsub(/^( +).+/m,'\1').length
    string.gsub(/^ {#{depth}}/, '')
  end
end

node[:jenkins_integration][:pantries].each_pair do |name, attrs|
  jenkins_job name do
    project       attrs[:project]
    repository    attrs[:repository]
    branches      ( attrs[:branches] || 'master' )
    downstream    [ 'Ironfan CI' ]
    triggers({ :github => true})
  end
end

# FIXME: Set up trigger from CI job to pantry publication
# - how do I split publication between branches afterward?
#   - single downstream that detects all the changes?
#   - split this into two parallel jobs?
jenkins_job 'Ironfan CI' do
  repository    node[:jenkins_integration][:ironfan_ci][:repository]
  branches      node[:jenkins_integration][:ironfan_ci][:branches]
  # Some short justification: why bash? Because that's the command line
  #   that these tools are written for. We can test internal interfaces
  #   via ruby, but external ones should mimic the command line closely.
  templates     [ 'knife_shared.inc' ]
  tasks         [ 'bundler.sh', 'full_sync.sh', 'launch.sh' ]
end

# Setup jenkins user to make commits
template node[:jenkins][:server][:home_dir] + '/.gitconfig' do
  source        '.gitconfig.erb'
  owner         node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
end

# FIXME: fucking omnibus
file node[:jenkins][:server][:home_dir] + '/.profile' do
  content       'export PATH=/opt/chef/embedded/bin/:$PATH'
  owner         node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
end
