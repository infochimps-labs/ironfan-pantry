#
# Cookbook Name::       zabbix
# Description::         Installs and launches Zabbix server.
# Recipe::              java_gateway
# Author::              Dhruv Bansal (<dhruv.bansal@infochimps.com>))
#
# Copyright 2012-2013, Infochimps
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

include_recipe("zabbix::default")

standard_dirs('zabbix.java_gateway') do
  directories :log_dir
end

template "/usr/local/sbin/zabbix_java/settings.sh" do
  source 'zabbix_java_gateway_settings.sh.erb'
  mode   '755'
  notifies  :restart, "service[zabbix_java]", :delayed
end

runit_service "zabbix_java"
