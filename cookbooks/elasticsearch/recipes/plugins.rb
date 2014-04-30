#
# Cookbook Name::       elasticsearch
# Description::         Install Plugins
# Recipe::              plugins
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

directory "#{node[:elasticsearch][:home_dir]}/plugins" do
  owner         "root"
  group         "root"
  mode          0755
end

node[:elasticsearch][:plugins].each do |plugin|
  if plugin.respond_to?(:to_hash)
    plugin_hsh = Mash.new(plugin.to_hash)
    plugin_hsh[:dir]  ||= plugin_hsh[:name]
    plugin_hsh[:slug] ||= [plugin_hsh[:org], plugin_hsh[:name], plugin_hsh[:version], ""].compact.join('/')
  else
    plugin_hsh =
      case plugin
      when %r{\A([^/]+)/([^/]+)/([^/]+)\z} then { name: $2, org: $1, version: $3, dir: $2, slug: plugin }
      when %r{\A([^/]+)/([^/]+)\z}         then { name: $2, org: $1,              dir: $2, slug: plugin }
      else                                      { name: plugin,                            slug: plugin }
      end
    Chef::Log.warn "Please specify a hash, not a string, for plugin names: instead of #{plugin}, something like '#{plugin_hsh.inspect}' (see cookbooks/elasticsearch/attributes/default.rb)"
  end
  Chef::Log.debug plugin_hsh
  #
  bash "install #{plugin_hsh[:name]} plugin for elasticsearch" do
    user          "root"
    cwd           "#{node[:elasticsearch][:home_dir]}"
    code          "./bin/plugin --install #{plugin_hsh[:slug]}"
    not_if{ plugin_hsh[:dir] && File.exist?("#{node[:elasticsearch][:home_dir]}/plugins/#{plugin_hsh[:dir]}")  }
  end
end
