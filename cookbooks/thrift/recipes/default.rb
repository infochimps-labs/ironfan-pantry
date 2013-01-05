#
# Cookbook Name:: thrift
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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

version = node['thrift']['version']

include_recipe "build-essential"
include_recipe "boost"
include_recipe "python"
include_recipe "install_from"

# no seriously -- thrift wants these ancient and unjustified gem versions
gem_package('rspec'){   version '1.3.2';      action :install }
gem_package('mongrel'){ version '1.2.0.pre2'; action :install; options("--prerelease --no-rdoc --no-ri") }

packages = value_for_platform(
  ["centos", "redhat", "suse", "fedora" ] => {
    "default" => %w{ flex bison libtool autoconf pkgconfig }
  },
  "default" => %w{ flex bison libtool autoconf pkg-config }
)
packages.each do |pkg|
  package pkg
end

install_from_release(:thrift) do
  release_url   node[:thrift][:release_url]
  version       node[:thrift][:version]
  checksum      node[:thrift][:checksum]
  home_dir      node[:thrift][:home_dir]
  action        [:configure_with_autoconf, :install_with_make]
  autoconf_opts [node[:thrift][:configure_options], "--prefix #{node[:thrift][:prefix_root]}"].flatten.compact
  not_if{ ::File.file?("#{node[:thrift][:prefix_root]}/lib/libthrift-#{node[:thrift][:version]}.jar") }
end

# Tell everyone about all the awesome jars of stuff we have

node.set[:thrift][:exported_jars] = [
  "#{node[:thrift][:home_dir]}/lib/java/build/libthrift-0.8.0.jar",
]
