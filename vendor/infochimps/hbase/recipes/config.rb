#
# Cookbook Name::       hbase
# Description::         HBase Config files
# Recipe::              config
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

include_recipe "hbase"

#
# Configuration files
#
hbase_config = Mash.new({
  :namenode_fqdn   => (discover(:hadoop, :namenode)   && discover(:hadoop, :namenode  ).private_hostname),
  :jobtracker_addr => (discover(:hadoop, :jobtracker) && discover(:hadoop, :jobtracker).private_ip),
  :zookeeper_addrs => discover_all(:zookeeper, :server).map(&:private_ip).sort,
  :ganglia         => discover(:ganglia, :server),
  :ganglia_addr    => (discover(:ganglia, :server) && discover(:ganglia, :server).private_hostname),
  :private_ip      => private_ip_of(node),
  :ganglia_port    => 8649,
  :period          => 10
  })


[:hadoop].each do |component|
  next unless node[component]
  Array(node[component][:exported_jars]).flatten.each do |export|
    link "#{node[:hbase][:home_dir]}/lib/#{File.basename(export)}" do
      to  export
    end
  end



  # FIXME: this is brittle, but the best I can do. can you do better?
  Array(node[component][:exported_libs]).flatten.each do |export|
    pathsegs = export.gsub(%r{\A.*/native/([\w\.\-]+)/([^/]+)\z}, '\1/\2')
    Chef::Log.info( [ 'hbase using hadoop native libs', pathsegs, node[:hadoop][:exported_libs], node[:hbase][:home_dir] ].inspect )
    link "#{node[:hbase][:home_dir]}/lib/native/#{pathsegs}" do
      to  export
    end
  end
end


%w[ hbase-env.sh hbase-site.xml hadoop-metrics.properties ].each do |conf_file|
  template "#{node[:hbase][:conf_dir]}/#{conf_file}" do
    owner       "root"
    mode        "0644"
    source      "#{conf_file}.erb"
    variables(hbase_config.merge(:hbase => node[:hbase]))
    notify_startable_services(:hbase, node[:hbase][:services])
  end
end

template "/etc/default/hbase" do
  owner         "root"
  mode          "0644"
  source        "etc_default_hbase.erb"
  variables(hbase_config.merge(:hbase => node[:hbase]))
  notify_startable_services(:hbase, node[:hbase][:services])
end

template "#{node[:hbase][:home_dir]}/bin/hbase" do
  owner         "root"
  mode          "0755"
  source        "bin-hbase.erb"
  variables(hbase_config.merge(:hbase => node[:hbase]))
  notify_startable_services(:hbase, node[:hbase][:services])
end

if node[:hadoop] && node[:hadoop][:conf_dir]
  link "#{node[:hadoop][:conf_dir]}/hbase-site.xml" do
    to "#{node[:hbase][:conf_dir]}/hbase-site.xml"
    only_if{ File.exists?(node[:hadoop][:conf_dir]) }
  end
end
