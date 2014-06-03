#
# Cookbook Name::       impala
# Description::         Base configuration for impala
# Recipe::              default
# Author::              Travis Dempsey
#
# Copyright 2009, Opscode, Inc.
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
if node[:hadoop][:distribution][:provider] == 'cloudera'
  yum_repository 'cdh-impala' do
    description  "Cloudera's Distribution for Imapala"
    baseurl      'http://archive.cloudera.com/impala/redhat/6/x86_64/impala/1/'
    keyurl       'http://archive.cloudera.com/impala/redhat/6/x86_64/impala/RPM-GPG-KEY-cloudera'
    action       :add
  end
else
  raise "Hadoop provider #{node[:hadoop][:distribution][:provider].inspect} cannot install Impala at this time, only Cloudera distributions!"
end

daemon_user 'impala'

group 'hadoop' do
  gid     node[:groups]['hadoop'][:gid]
  action  [:create, :manage]
  append  true
  members ['impala']
end

standard_dirs('impala') do
  directories :conf_dir
end

package 'impala'

# Impala log storage on a single scratch dir
volume_dirs('impala.log') do
  type    :local
  selects :single
  path    'impala/log'
  owner   node[:impala][:user]
  group   node[:impala][:group]
  mode    '0777'
end

directory('/var/log/impala') do
  action    :delete
  recursive true
  not_if    'test -L /var/log/impala'
end
link('/var/log/impala'){ to node[:impala][:log_dir] }

