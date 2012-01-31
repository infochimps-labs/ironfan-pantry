# Author:: Dhruv Bansal (<dhruv@infochimps.com>)
# Cookbook Name:: zabbix
# Recipe:: database
#
# Copyright 2012, Infochimps
#
# Apache 2.0
#

include_recipe "database"

include_recipe "zabbix::database_#{node.zabbix.database.install_method}"
