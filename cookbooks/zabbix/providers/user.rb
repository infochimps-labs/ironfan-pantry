include Chef::RubixConnection

action :create do
  zabbix_user.save if connected_to_zabbix? && zabbix_user
end

action :destroy do
  zabbix_user.destroy if connected_to_zabbix? && zabbix_user
end

attr_accessor :zabbix_user

def load_current_resource
  return unless connect_to_zabbix_server(new_resource.server)
  begin
    self.zabbix_user           = (Rubix::User.find(:username => new_resource.name) || Rubix::User.new(:username => new_resource.name))
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
        media_type = Rubix::MediaType.find(:name => medium[:media_type_name])
        if media_type
          medium[:media_type] = media_type
          medium
        else
          ::Chef::Log.warn("Could not find media type #{medium[:media_type_name]} for Zabbix user #{new_resource.name}, skpping")
          nil
        end
      end.compact
    end
  rescue ArgumentError, ::Rubix::Error, ::Errno::ECONNREFUSED => e
    ::Chef::Log.warn("Could not create Zabbix user #{new_resource.name}: #{e.message}")
  end
end
