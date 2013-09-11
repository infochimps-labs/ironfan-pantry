#
# Cookbook Name::       zabbix
# Description::         Downloads, builds, configures, & launches Zabbix agent from source.
# Recipe::              agent_source
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
  %w{ fping libcurl3 libiksemel-dev libiksemel3 libsnmp-dev libiksemel-utils libcurl4-openssl-dev }.each do |pck|
    package "#{pck}"
  end
when "centos", "redhat"
  # do nothing special?
else
  warn "No #{node.platform} support yet for building Zabbix agent from source"
end

install_from_release('zabbix') do
  action        [:configure_with_autoconf, :install_with_make]
  release_url   node.zabbix.release_url
  version       node.zabbix.agent.version
  autoconf_opts ['--enable-agent'].concat(node.zabbix.agent.configure_options)
  not_if        { File.exist?('/usr/local/bin/zabbix_agentd') }
end
