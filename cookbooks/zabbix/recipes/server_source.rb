#
# Cookbook Name::       zabbix
# Description::         Downloads, builds, configures, & launches Zabbix server from source.
# Recipe::              server_source
# Author::              Dhruv Bansal (<dhruv@infochimps.com>), Nacer Laradji (<nacer.laradji@gmail.com>)
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

case node[:platform]
when "ubuntu","debian"
  %w{ fping libmysql++-dev libmysql++3 libcurl3 libiksemel-dev libiksemel3 libsnmp-dev snmp libiksemel-utils libcurl4-openssl-dev }.each do |pck|
    package "#{pck}" do
      action :install
    end
  end
when "centos", "redhat"
  %w{ libcurl-devel net-snmp-devel }.each do |pck|
    package "#{pck}" do
      action :install
    end
  end
else
  warn "No #{node.platform} support yet for building Zabbix server from source"
end

install_from_release('zabbix') do
  action        [:configure_with_autoconf, :install_with_make]
  release_url   node.zabbix.release_url
  version       node.zabbix.server.version
  autoconf_opts ['--enable-server'].concat(node.zabbix.server.configure_options)
  not_if        { File.exist?('/usr/local/sbin/zabbix_server') }
end
