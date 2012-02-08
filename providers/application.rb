include Chef::RubixConnection

action :create do
  return unless connected_to_zabbix? && self.zabbix_host
  Rubix::Application.find_or_create(:host_id => self.zabbix_host.id, :name => new_resource.name)
end

action :destroy do
  return unless connected_to_zabbix? && self.zabbix_host
  app = Rubix::Application.find(:host_id => self.zabbix_host.id, :name => new_resource.name)
  app.destroy if app
end

attr_accessor :zabbix_host

def load_current_resource
  return unless connect_to_zabbix_server(new_resource.server)
  begin
    self.zabbix_host = Rubix::Host.find(:name => new_resource.host)
    Chef::Log.error("Cannot find a Zabbix host named #{new_resource.host}") unless self.zabbix_host
  rescue ArgumentError, ::Rubix::Error, ::Errno::ECONNREFUSED => e
    ::Chef::Log.warn("Could not create Zabbix application #{new_resource.name}: #{e.message}")
  end
end
