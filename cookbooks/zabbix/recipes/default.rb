#
# Cookbook Name::       zabbix
# Description::         Sets up Zabbix user and directories shared by agent and server
# Recipe::              default
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

daemon_user(:zabbix) do
  comment       "zabbix runner"
  shell         "/bin/bash"
end

# These directories are used by both server & agent installations
standard_dirs('zabbix') do
  directories :conf_dir, :pid_dir
end
%w[include external_scripts alert_scripts].each do |sub_dir|
  directory File.join(node[:zabbix][:conf_dir], sub_dir) do
    action :create
    mode   '0755'
  end
end
