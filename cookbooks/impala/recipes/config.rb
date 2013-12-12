 #
# Cookbook Name::       impala
# Description::         Configures Impala
# Recipe::              config
# Author::              Josh Bronson - Infochimps, Inc
#
# Copyright 2012 Infochimps, Inc
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

include_recipe 'hive'
include_recipe 'hadoop'

metastore   = discover(:hive, :metastore)
state_store = discover(:impala, :state_store)

template_variables = {
  :hive   => node[:hive],
  :impala => node[:impala],
  :hadoop => node[:hadoop],
  :hue    => node[:hue],
  :state_store => { :host => state_store ? state_store.private_ip : nil },
  :metastore =>   { :host => metastore   ? metastore.private_ip   : nil }
}

template "/etc/default/impala" do
  owner "root"
  mode "0644"
  variables template_variables
  source "etc_default_impala.erb"
  notify_startable_services(:impala, [:server, :state_store])
end

template File.join(node[:impala][:conf_dir], 'hive-site.xml') do
  mode "0644"
  variables template_variables
  source "hive-site.xml.erb"
  notify_startable_services(:impala, [:server, :state_store])
end

template File.join(node[:impala][:conf_dir], 'impala-env.sh') do
  mode "0644"
  variables template_variables
  source "impala-env.sh.erb"
  notify_startable_services(:impala, [:server, :state_store])
end

template File.join(node[:impala][:conf_dir], 'hdfs-site.xml') do
  mode "0644"
  variables template_variables
  source "hdfs-site.xml.erb"
  notify_startable_services(:impala, [:server, :state_store])
end

template File.join(node[:impala][:conf_dir], 'core-site.xml') do
  mode "0644"
  variables template_variables
  source "core-site.xml.erb"
  notify_startable_services(:impala, [:server, :state_store])
end
