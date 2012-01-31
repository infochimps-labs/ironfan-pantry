#
# Cookbook Name::       zabbix
# Description::         Configures Zabbix server to be able to send texts using Twilio.
# Recipe::              server_sends_texts
# Author::              Dhruv Bansal (<dhruv@infochimps.com>)
#
# Copyright 2012, Infochimps
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

# http://conoroneill.net/monitoring-ec2-servers-with-zabbix

%w[id token phone].each do |prop|
  value = node.zabbix.twilio.send(prop)
  Chef::Log.warn("node[:zabbix][:twilio][:#{prop}] is blank; Zabbix server will not be able to send texts.") if value.nil? || value.empty?
end
template "/opt/zabbix/AlertScriptsPath/zabbix_sendtext" do
  source 'zabbix_sendtext.erb'
  owner 'zabbix'
  group 'admin'
  mode 0770
  action :create
end
