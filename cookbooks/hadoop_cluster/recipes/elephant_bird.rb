#
# Cookbook Name:: hadoop
# Recipe:: lzo
#
# Copyright 2012 Infochimps.com
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

execute "run ldconfig" do
  action :nothing
  command "ldconfig"
end

case node[:platform_version] 
when "11.04"
  package "protobuf-compiler"
else
  install_from_release('protobuf-compiler') do
    release_url node[:hadoop][:elephant_bird][:protobuf_url]
    version     node[:hadoop][:elephant_bird][:protobuf_ver]  
    action      [ :configure_with_autoconf, :install_with_make, :install ]
    not_if      { File.exists?("/usr/local/lib/libprotobuf.so") }
    notifies    :run,  resources(:execute => "run ldconfig"), :immediately
  end
end

git_repo = node[:hadoop][:elephant_bird][:git_repo]
build_dir = node[:hadoop][:elephant_bird][:build_dir]
version = node[:hadoop][:elephant_bird][:version]

git build_dir do
  repository    git_repo
  action        :sync
  group         'admin'
  revision      "elephant-bird-#{version}"
end

bash 'compile elephant-bird' do
  user         'root'
  cwd          build_dir
  code "mvn package -DskipTests=true"
  not_if { File.exists? File.join(build_dir, "elephant-bird-core-#{version}.jar") }
end

bash 'install elephant-bird' do
  user         'root'
  cwd          build_dir
  code([
        "cp ./core/target/elephant-bird-core-#{version}.jar",
        File.join(node[:hadoop][:home_dir], 'lib'),
        ].join(" "))
end
