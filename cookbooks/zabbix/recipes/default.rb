#
# Cookbook Name::       zabbix
# Description::         Sets up Zabbix directory structure & user.
# Recipe::              default
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

include_recipe "silverware"

# Create zabbix User
daemon_user(:zabbix) do
  comment       "zabbix runner"
  home          "/opt/zabbix"
  shell         "/bin/bash"
end

# Define zabbix Agent folder
zabbix_dirs = [
  "/etc/zabbix",
  "/etc/zabbix/include",
  "/opt/zabbix",
  "/opt/zabbix/bin",
  "/opt/zabbix/sbin",
  "/var/run/zabbix",
  "/etc/zabbix/externalscripts",
  "/opt/zabbix/AlertScriptsPath"
]

# Create zabbix folder
zabbix_dirs.each do |dir|
  directory dir do
    owner "zabbix"
    group "zabbix"
    mode "755"
  end
end
