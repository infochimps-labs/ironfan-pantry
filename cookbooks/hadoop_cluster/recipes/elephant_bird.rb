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

package "protobuf-compiler"

github  = node[:hadoop][:elephant_bird][:github]
archive = node[:hadoop][:elephant_bird][:archive]
version = node[:hadoop][:elephant_bird][:version]

# git_private_repo 'elephant_bird' do
#   repository github
#   branch version
#   path "/usr/local/src/#{archive}"
# end

remote_file "/usr/local/src/#{archive}.tar.gz" do
  source github
  mode "0644"
end

execute "tar zxvf #{archive}.tar.gz" do
  cwd "/usr/local/src"
  creates "/usr/local/src/#{archive}"
end

execute "ant jar" do
  cwd "/usr/local/src/#{archive}"
  environment( 'JAVA_HOME' => node[:java][:java_home] )
  creates "/usr/local/src/#{archive}/build/elephant-bird-#{version}.jar"
end

execute "cp elephant-bird-#{node[:hadoop][:elephant_bird][:version]}.jar /usr/lib/hadoop-0.20/lib" do
  cwd "/usr/local/src/#{node[:hadoop][:elephant_bird][:archive]}/build"
  creates "/usr/lib/hadoop-0.20/lib/elephant-bird-#{node[:hadoop][:elephant_bird][:version]}.jar"
end
