include Chef::RubixConnection

action :create do
  zabbix_user_group.save if connected_to_zabbix? && self.zabbix_user_group
end

action :destroy do
  zabbix_user_group.destroy if connected_to_zabbix? && self.zabbix_user_group
end

attr_accessor :zabbix_user_group, :zabbix_users

def load_current_resource
  return unless connect_to_zabbix_server(new_resource.server)
  begin
    self.zabbix_users                 = new_resource.users.map { |username| Rubix::User.find(:username => username) }.compact
    self.zabbix_user_group            = (Rubix::UserGroup.find(:name => new_resource.name) || Rubix::UserGroup.new(:name => new_resource.name))
    self.zabbix_user_group.users      = self.zabbix_users
    self.zabbix_user_group.debug_mode = new_resource.debug_mode
    self.zabbix_user_group.gui_access = new_resource.gui_access
    self.zabbix_user_group.banned     = new_resource.banned
  rescue ArgumentError, ::Rubix::Error, ::Errno::ECONNREFUSED => e
    ::Chef::Log.warn("Could not create Zabbix user group #{new_resource.name}: #{e.message}")
  end
end
