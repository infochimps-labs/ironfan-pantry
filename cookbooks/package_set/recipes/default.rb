#
# Cookbook Name::       package_set
# Description::         Base configuration for package_set
# Recipe::              default
# Author::              Philip (flip) Kromer - Infochimps, Inc
#
# Copyright 2011, Philip (flip) Kromer - Infochimps, Inc
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

Chef::Log.debug node[:package_set][:install]
# node[:package_set][:install].map!(&:to_s)

packages = node[:package_set][:pkgs].map do |set_name, pkgs|
  next unless node[:package_set][:install].include?(set_name.to_s)
  pkgs.map do |pkg|
    pkg.is_a?(String) ? { :name => pkg } : pkg
  end
end.flatten.compact.uniq

gem_packages = node[:package_set][:gems].map do |set_name, gems|
  next unless node[:package_set][:install].include?(set_name.to_s)
  gems.map do |gem|
    gem.is_a?(String) ? { :name => gem } : gem
  end
end.flatten.compact.uniq

Chef::Log.debug [packages, gem_packages, node[:package_set][:install] ].inspect


packages.each do |pkg|
  package pkg[:name] do
    version   pkg[:version] if pkg[:version]
    source    pkg[:source]  if pkg[:source]
    options   pkg[:options] if pkg[:options]
    action    pkg[:action] || :install
  end
end

gem_packages.each do |gem|
  gem_package gem[:name] do
    version   gem[:version] if gem[:version]
    source    gem[:source]  if gem[:source]
    options   gem[:options] if gem[:options]
    action    gem[:action] || :install
  end
end
