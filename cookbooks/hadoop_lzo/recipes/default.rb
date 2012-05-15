#
# Cookbook Name:: hadoop-lzo
# Recipe:: default
#
# Copyright 2012, Infochimps.com
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'ant'
include_recipe 'install_from'

package "sun-java6-jdk"
package "sun-java6-bin"
package "sun-java6-jre"

package "ivy"

install_from_release('hadoop_lzo') do
  release_url   node[:hadoop_lzo][:release_url]
  home_dir      node[:hadoop_lzo][:home_dir]
  version       node[:hadoop_lzo][:version]
  action        [:build_with_ant, :install]
  environment('JAVA_HOME' => node[:java][:java_home]) if node[:java][:java_home]

  not_if{ ::File.exists?("#{node[:hadoop_lzo][:home_dir]}/hadoop_lzo.jar") }
  # not_if_exists './pig.jar'
end

