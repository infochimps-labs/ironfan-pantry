include Chef::RubixConnection

action :create do
  zabbix_host_group.save if connected_to_zabbix?
end

action :destroy do
  zabbix_host_group.destroy if connected_to_zabbix?
end

attr_accessor :zabbix_host_group

def load_current_resource
  return unless connect_to_zabbix_server(new_resource.server)
  self.zabbix_host_group = Rubix::HostGroup.find_or_create(:name => new_resource.name)
end
