#
# Cookbook Name::       zabbix
# Description::         Configures Zabbix database.
# Recipe::              database
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

# Force download, unpack, and symlink during compile time so database
# schema is on disk ready to be loaded at converge time.
install_from_release('zabbix') do
  action        :nothing
  release_url   node.zabbix.release_url
  version       node.zabbix.server.version
  not_if        { File.exist?(node.zabbix.home_dir) }
end.run_action(:configure)      

case node.zabbix.database.install_method
when 'mysql'
  include_recipe "zabbix::database_#{node.zabbix.database.install_method}"
else
  warn "Invalid method '#{node.zabbix.database.install_method}'.  Only the 'mysql' install method is currently supported for Zabbix database."
end

