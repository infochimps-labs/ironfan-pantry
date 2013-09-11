#
# Cookbook Name::       zabbix
# Description::         Configures PHP-driven, reverse-proxied Zabbix web frontend using nginx.
# Recipe::              web_nginx
# Author::              Dhruv Bansal (<dhruv@infochimps.com>)
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

include_recipe 'nginx'

template File.join(node[:nginx][:dir], "sites-available", "zabbix.conf") do
  source 'zabbix_web.nginx.conf.erb'
  action :create
  notifies  :restart, "service[nginx]", :delayed
end

nginx_site 'zabbix.conf' do
  action   :enable
  notifies :restart, 'service[nginx]', :delayed
end

nginx_site 'default' do
  enable false
end

runit_service "zabbix_web"

announce(:zabbix, :web, {
  logs:  { 
    php_cgi: { path: File.join(node.zabbix.web.log_dir, 'php.*')   },
    nginx:   { path: File.join(node.zabbix.web.log_dir, 'nginx.*') }
  },
  ports: {
    php_cgi: {
      port:      node.zabbix.web.port,
      protocol:  'http'
    }
  },
  daemons: {
    php_cgi:  {
      name:  'php-cgi',
      cmd:   'zabbix'
    }
  }
})
