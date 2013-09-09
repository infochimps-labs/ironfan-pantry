include Chef::RubixConnection

action :create do
  zabbix_media_type.save if connected_to_zabbix? && self.zabbix_media_type
end

action :destroy do
  zabbix_media_type.destroy if connected_to_zabbix? && self.zabbix_media_type
end

attr_accessor :zabbix_media_type

def load_current_resource
  return unless connect_to_zabbix_server(new_resource.server)
  begin
    self.zabbix_media_type             = (Rubix::MediaType.find(:name => new_resource.name) || Rubix::MediaType.new(:name => new_resource.name))
    self.zabbix_media_type.type        = new_resource.type
    self.zabbix_media_type.path        = new_resource.path        if new_resource.path
    self.zabbix_media_type.smtp_server = new_resource.smtp_server if new_resource.smtp_server
    self.zabbix_media_type.email       = new_resource.email       if new_resource.email
    self.zabbix_media_type.helo        = new_resource.helo        if new_resource.helo
    self.zabbix_media_type.modem       = new_resource.modem       if new_resource.modem
    self.zabbix_media_type.username    = new_resource.username    if new_resource.username
    self.zabbix_media_type.password    = new_resource.password    if new_resource.password
  rescue ArgumentError, ::Rubix::Error, ::Errno::ECONNREFUSED => e
    ::Chef::Log.warn("Could not create Zabbix media type #{new_resource.description}: #{e.message}")
  end
end
