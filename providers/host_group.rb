action :create do
  zabbix_host_group.save
end

action :destroy do
  zabbix_host_group.destroy
end

attr_accessor :zabbix_host_group

def load_current_resource
  self.zabbix_host_group = Rubix::HostGroup.find_or_create(:name => new_resource.name)
end
