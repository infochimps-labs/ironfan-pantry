# Author:: Nacer Laradji (<nacer.laradji@gmail.com>)
# Cookbook Name:: zabbix
# Recipe:: mysql_setup
#
# Copyright 2011, Efactures
#
# Apache 2.0
#

include_recipe "mysql::client"

# Establish root MySQL connection
root_mysql_conn = {:host => node.zabbix.database.host, :username => node.zabbix.database.root_user, :password => node.zabbix.database.root_password}

begin
  # Determine whether Zabbix database already exists? (Connecting as root)
  gem_package "mysql" do
    action :install
  end
  Gem.clear_paths  
  require 'mysql'
  m=Mysql.new(node.zabbix.database.host,node.zabbix.database.root_user,node.zabbix.database.root_password)
  if m.list_dbs.include?(node.zabbix.database.name) == false

    # Create Zabbix database (connecting as root)
    mysql_database node.zabbix.database.name do
      connection root_mysql_conn
      action     :create
      notifies   :run,    "execute[zabbix_populate_schema]"
      notifies   :run,    "execute[zabbix_populate_data]"
      notifies   :run,    "execute[zabbix_populate_image]"
      notifies   :create, "template[/etc/zabbix/zabbix_server.conf]"
    end

    # Create Zabbix database user (connecting as root)
    mysql_database_user node.zabbix.database.user do
      connection root_mysql_conn
      password   node.zabbix.database.password
      action     :create
    end

    # Populate Zabbix database (connecting as root)
    execute "zabbix_populate_schema" do
      command "/usr/bin/mysql -h #{node.zabbix.database.host} -u #{node.zabbix.database.root_user} #{node.zabbix.database.name} -p#{node.zabbix.database.root_password} < /opt/zabbix-#{node.zabbix.server.version}/create/schema/mysql.sql"
      action :nothing
    end
    execute "zabbix_populate_data" do
      command "/usr/bin/mysql -h #{node.zabbix.database.host} -u #{node.zabbix.database.root_user} #{node.zabbix.database.name} -p#{node.zabbix.database.root_password} < /opt/zabbix-#{node.zabbix.server.version}/create/data/data.sql"
      action :nothing
    end
    execute "zabbix_populate_image" do
      command "/usr/bin/mysql -h #{node.zabbix.database.host} -u #{node.zabbix.database.root_user} #{node.zabbix.database.name} -p#{node.zabbix.database.root_password} < /opt/zabbix-#{node.zabbix.server.version}/create/data/images_mysql.sql"
      action :nothing
    end

    # Grant Zabbix user credentials for created, populated Zabbix
    # database (connecting as root)
    mysql_database_user node.zabbix.database.user do
      connection    root_mysql_conn
      password      node.zabbix.database.password      
      host          node.zabbix.database.host      
      database_name node.zabbix.database.name
      privileges    [:select,:update,:insert,:create,:drop,:delete]
      action        :grant
    end
  end
rescue LoadError
  Chef::Log.conn("Missing gem 'mysql'")
end

