#
# Cookbook Name::       zabbix
# Description::         Configures PHP-driven, reverse-proxied Zabbix web frontend.
# Recipe::              web
# Author::              Dhruv Bansal (dhruv@infochimps.com), Nacer Laradji (<nacer.laradji@gmail.com>)
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

case node[:platform]
when "ubuntu","debian"
  %w[traceroute php5-cgi php5-mysql php5-gd].each { |name| package(name) }
when "centos", "redhat"
  %w[traceroute php php-mysql php-gd php-bcmath php-mbstring php-xml].each { |name| package(name) }
else
  log "No #{node.platform} support yet for Zabbix web"
end

standard_dirs('zabbix.web') do
  directories :log_dir, :tmp_dir
end

install_from_release('zabbix') do
  action        :configure
  release_url   node.zabbix.release_url
  version       node.zabbix.server.version
  notifies      :run, 'bash[chown_zabbix_web]', :delayed
  not_if        { File.exist?(node.zabbix.web.home_dir) }
end

bash "chown_zabbix_web" do
  action :nothing
  code "chown -R #{node.zabbix.web.user} #{node.zabbix.web.home_dir}"
end

logs    = {}
ports   = {}
daemons = {}

node[:zabbix][:web][:num_daemons].times do |i|
  
  service_name = "zabbix_web_#{i}"
  aspect  = service_name.to_sym
  socket  = File.join(node[:zabbix][:web][:tmp_dir], "php-#{i}.sock")
  log_dir = File.join(node[:zabbix][:web][:log_dir], i.to_s)

  directory log_dir do
    owner  node[:zabbix][:web][:user]
    group  node[:zabbix][:web][:group]
    mode   '0775'
    action :create
  end

  runit_service service_name do
    template_name "zabbix_web"
    options({
      log_dir: log_dir,
      socket:  socket,
    })
  end

  logs[aspect]  = { path: log_dir }
  daemons[aspect] = {
    service: service_name,
    name:    'php-cgi',
    user:    node[:zabbix][:web][:user],
    cmd:     "php-#{i}.*zabbix",
  }
end

case node.zabbix.web.install_method
when 'nginx'
  include_recipe "zabbix::web_#{node.zabbix.web.install_method}"
  ports[:nginx] = { port: node[:zabbix][:web][:port], protocol: 'http' }
  logs[:nginx]  = { path: File.join(node[:zabbix][:web][:log_dir], 'nginx.*') }
else
  warn "Invalid install method '#{node.zabbix.web.install_method}'.  Only 'nginx' is supported for Zabbix web."
end

template File.join(node.zabbix.conf_dir, "php.ini") do
  source   'php.ini.erb'
  owner    node.zabbix.web.user
  mode     '0400'
  action   :create
  node[:zabbix][:web][:num_daemons].times do |i|
    notifies :restart, "service[zabbix_web_#{i}]", :delayed
  end
end

template File.join(node.zabbix.web.home_dir, 'conf', 'zabbix.conf.php') do
  source    'zabbix.conf.php.erb'
  owner     node.zabbix.web.user
  mode      '0400'
  action    :create
  node[:zabbix][:web][:num_daemons].times do |i|
    notifies  :restart, "service[zabbix_web_#{i}]", :delayed
  end
end

announce(:zabbix, :web, {
  logs:    logs,
  ports:   ports,
  daemons: daemons,
})
