#
# Cookbook Name::       graphite
# Description::         Web
# Recipe::              web
# Author::              Heavy Water Software Inc.
#
# Copyright 2011, Heavy Water Software Inc.
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

include_recipe "apache2::mod_python"
include_recipe "runit"
include_recipe 'install_from'

package "python-cairo-dev"
package "python-django"
package "python-memcache"
package "python-rrdtool"

install_from_release('graphite_web') do
  version       node[:graphite][:graphite_web][:version]
  release_url   node[:graphite][:graphite_web][:release_url]
  home_dir      node[:graphite][:graphite_web][:home_dir]
  checksum      node[:graphite][:graphite_web][:release_url_checksum]
  action        [:install]
end

graphite_web_version = node[:graphite][:graphite_web][:version]
graphite_web_dir = node[:graphite][:graphite_web][:home_dir] ||
  "/usr/local/share/graphite_web"

execute "install graphite-web" do
  command       "python setup.py install"
  creates       "#{graphite_web_dir}/webapp/graphite_web-#{graphite_web_version}-py2.6.egg-info"
  cwd           graphite_web_dir
end

template "#{node[:apache][:dir]}/sites-available/graphite.conf" do
  mode          0644
  variables     :web_dir => graphite_web_dir,
                :log_dir => node[:graphite][:log_dir]
  source        "graphite-vhost.conf.erb"
end

template "#{graphite_web_dir}/webapp/graphite/local_settings.py" do
  mode          0644
  variables     :web_dir => graphite_web_dir,
                :data_dir => node[:graphite][:data_dir],
                :log_dir => node[:graphite][:log_dir]
  source        "graphite-settings.py.erb"
end

cookbook_file "#{graphite_web_dir}/webapp/graphite/urls.py.patch" do
  owner         node[:graphite][:graphite_web][:user]
  group         node[:graphite][:graphite_web][:user]
  action        :create_if_missing
end

execute "patch urls.py" do
  command       "patch -N -r - < urls.py.patch"
  cwd           "#{graphite_web_dir}/webapp/graphite"
  returns       [0, 1]          # it's okay if already applied
end

apache_site "000-default" do
  enable        false
end

apache_site "graphite.conf"

directory "#{node[:graphite][:log_dir]}" do
  owner         node[:graphite][:graphite_web][:user]
  group         node[:graphite][:graphite_web][:user]
end

directory "#{node[:graphite][:log_dir]}/webapp" do
  owner         node[:graphite][:graphite_web][:user]
  group         node[:graphite][:graphite_web][:user]
end

directory "#{node[:graphite][:data_dir]}" do
  owner         node[:graphite][:graphite_web][:user]
  group         node[:graphite][:graphite_web][:user]
end

cookbook_file "#{node[:graphite][:data_dir]}/graphite.db" do
  owner         node[:graphite][:graphite_web][:user]
  group         node[:graphite][:graphite_web][:user]
  action        :create_if_missing
end
