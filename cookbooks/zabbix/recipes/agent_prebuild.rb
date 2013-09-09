#
# Cookbook Name::       zabbix
# Description::         Downloads, configures, & launches pre-built Zabbix agent
# Recipe::              agent_prebuild
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

case node.kernel.machine
when "x86_64"
  zabbix_arch = "amd64"
when "i686"
  zabbix_arch = "i386"
else
  warn("Possibly unsupported architecture '#{node.kernel.machine}' for Zabbix agent.")
  zabbix_arch = node.kernel.machine
end

install_from_release('zabbix_agent') do
  action           :install
  release_url      node.zabbix.agent.prebuild_url.gsub(/:kernel:/,node.zabbix.agent.prebuild_kernel).gsub(/:arch:/,zabbix_arch)
  version          node.zabbix.agent.version
  has_binaries     %w[bin/zabbix_sender bin/zabbix_get sbin/zabbix_agent sbin/zabbix_agentd]
  strip_components 0            # the tarball is flat!
  not_if           { File.exist?('/usr/local/bin/zabbix_agentd') }
end
