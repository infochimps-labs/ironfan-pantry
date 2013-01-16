#
# Cookbook Name::       elasticsearch
# Description::         Install From Git
# Recipe::              install_from_git
# Author::              GoTime, modifications by Infochimps
#
# Copyright 2011, GoTime, modifications by Infochimps
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

include_recipe 'java' ; complain_if_not_sun_java(:elasticsearch)
package 'unzip'

#
# FIXME: integrate with install_from recipe
#

snapshot_suffix = node[:elasticsearch][:snapshot] ? '-SNAPSHOT' : ''

es_suffix    = ["-#{node[:elasticsearch][:version]}", snapshot_suffix].join
es_dist_name = ["elasticsearch"                  , es_suffix].join
es_dist_home = [node[:elasticsearch][:home_dir]  , es_suffix].join
es_zip_file  = "/usr/local/share/elasticsearch-git/target/releases/#{es_dist_name}.zip"

# install into eg. /usr/local/share/elasticsearch-git
git "#{node[:elasticsearch][:home_dir]}-git" do
  repository    node[:elasticsearch][:git_repo]
  action        :sync
  group         'admin'
  revision      node[:elasticsearch][:git_revision]
end

bash 'install from source' do
  user         'root'
  cwd          "#{node[:elasticsearch][:home_dir]}-git"
  code <<EOF
mvn package -DskipTests=true
EOF
  only_if{ not File.exists?(es_zip_file) }
end

# install into eg. /usr/local/share/elasticsearch-0.x.x ...
directory es_dist_home do
  owner       "root"
  group       "root"
  mode        0755
end
# ... and then force /usr/local/share/elasticsearch to link to the versioned dir
link node[:elasticsearch][:home_dir] do
  to es_dist_home
end

bash "unzip #{es_zip_file} to /tmp/#{es_dist_name}" do
  user          "root"
  cwd           "/tmp"
  code           %Q{
  cp #{es_zip_file} /tmp
  unzip /tmp/#{es_dist_name}.zip
  }
  not_if{ File.exists? "/tmp/#{es_dist_name}" }
end

bash "copy elasticsearch root" do
  user          "root"
  cwd           "/tmp"
  code          %(cp -r /tmp/#{es_dist_name}/* #{node[:elasticsearch][:home_dir]})
  not_if{ File.exists? "#{node[:elasticsearch][:home_dir]}/lib" }
end
