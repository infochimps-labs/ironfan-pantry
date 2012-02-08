include Chef::RubixConnection

action :create do
  zabbix_host_group.save if connected_to_zabbix? && self.zabbix_host_group
end

action :destroy do
  zabbix_host_group.destroy if connected_to_zabbix? && self.zabbix_host_group
end

attr_accessor :zabbix_host_group

def load_current_resource
  return unless connect_to_zabbix_server(new_resource.server)
  begin
    self.zabbix_host_group = Rubix::HostGroup.find_or_create(:name => new_resource.name)
  rescue ArgumentError, ::Rubix::Error, ::Errno::ECONNREFUSED => e
    ::Chef::Log.warn("Could not create Zabbix host group #{new_resource.name}: #{e.message}")
  end
end
