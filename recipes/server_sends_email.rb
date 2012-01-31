#
# Cookbook Name::       zabbix
# Description::         Configures Zabbix server to be able to send email via a remote SMTP server.
# Recipe::              server_sends_email
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

%w[sendEmail libio-socket-ssl-perl libnet-ssleay-perl].each { |name| package(name) }

%w[from server port username password].each do |prop|
  value = node.zabbix.smtp.send(prop)
  Chef::Log.warn("node[:zabbix][:smtp][:#{prop}] is blank; Zabbix server will not be able to send email.") if value.nil? || value.empty?
end

template "/opt/zabbix/AlertScriptsPath/zabbix_sendemail" do
  source 'zabbix_sendemail.erb'
  owner 'zabbix'
  group 'admin'
  mode 0770
  action :create
end
