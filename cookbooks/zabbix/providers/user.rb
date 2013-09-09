include Chef::RubixConnection

action :create do
  zabbix_user.save if connected_to_zabbix? && zabbix_user
end

action :destroy do
  zabbix_user.destroy if connected_to_zabbix? && zabbix_user
end

attr_accessor :zabbix_user

def all_users_group
  return @all_users_group if @all_users_group
  @all_users_group = Rubix::UserGroup.find(name: "All Users")
  unless @all_users_group
    @all_users_group = Rubix::UserGroup.new(name: "All Users")
    @all_users_group.save
  end
  @all_users_group
end

def add_default_user_group
  if zabbix_user.user_groups.nil? || zabbix_user.user_groups.empty? || zabbix_user.user_groups.all? { |user_group| user_group.name != all_users_group.name }
    zabbix_user.user_groups = (zabbix_user.user_groups || []) + [all_users_group]
  end
end

def load_current_resource
  return unless connect_to_zabbix_server(new_resource.server)
  begin
    self.zabbix_user                    = (Rubix::User.find(:username => new_resource.name) || Rubix::User.new(:username => new_resource.name))
    add_default_user_group
    self.zabbix_user.first_name         = new_resource.first_name
    self.zabbix_user.last_name          = new_resource.last_name
    self.zabbix_user.url                = new_resource.url
    self.zabbix_user.auto_login         = new_resource.auto_login
    self.zabbix_user.type               = new_resource.type
    self.zabbix_user.theme              = new_resource.theme
    self.zabbix_user.auto_logout_period = new_resource.auto_logout_period
    self.zabbix_user.refresh_period     = new_resource.refresh_period
    self.zabbix_user.rows_per_page      = new_resource.rows_per_page
    self.zabbix_user.password           = new_resource.password if new_resource.password
    if new_resource.media && (!new_resource.media.empty?)
      self.zabbix_user.media = new_resource.media.map do |medium|
        user_medium = medium.dup
        media_type = Rubix::MediaType.find(:name => user_medium[:media_type_name])
        if media_type
          user_medium[:media_type] = media_type
          user_medium
        else
          ::Chef::Log.warn("Could not find media type #{user_medium[:media_type_name]} for Zabbix user #{new_resource.name}, skpping")
          nil
        end
      end.compact
    end
  rescue ArgumentError, ::Rubix::Error, ::Errno::ECONNREFUSED => e
    ::Chef::Log.warn("Could not create Zabbix user #{new_resource.name}: #{e.message}")
  end
end
