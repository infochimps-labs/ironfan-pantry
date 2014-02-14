#
# Cookbook Name::       zabbix
# Description::         Installs and launches Zabbix server.
# Recipe::              server
# Author::              Dhruv Bansal (<dhruv.bansal@infochimps.com>)
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

directory node.zabbix.server.log_dir do
  owner 'zabbix'
  group 'zabbix'
  mode '0755'
end

include_recipe "zabbix::server_#{node.zabbix.server.install_method}"

announce(:zabbix, :server,
         :logs =>  { :server => node.zabbix.server.log_dir },
         :ports => {
           :server => {
             :port    => 10050,
             :monitor => false
           }
         },
         :daemons => { :server => 'zabbix_server' }
         )
