#
# Cookbook Name::       zabbix
# Description::         Configures PHP-driven, reverse-proxied Zabbix web frontend using Apache.
# Recipe::              web_apache
# Author::              Nacer Laradji (<nacer.laradji@gmail.com>)
#
# Copyright 2011, Efactures
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

# Execute apache2 receipe + mod_php5 receipe
include_recipe 'apache2'
include_recipe 'apache2::mod_php5'

if node[:zabbix][:web][:fqdn] != nil
  #install vhost for zabbix frontend
  web_app "#{node.zabbix.web.fqdn}" do
    server_name node.zabbix.web.fqdn
    server_aliases "zabbix"
    docroot "/opt/zabbix/web"
  end
end
