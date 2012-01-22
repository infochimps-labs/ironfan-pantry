action :create do
  zabbix_trigger.save
end

action :destroy do
  zabbix_trigger.destroy
end

attr_accessor :zabbix_trigger, :zabbix_host

def load_current_resource
  self.zabbix_host = Rubix::Host.find(:name => new_resource.host)
  unless self.zabbix_host
    Chef::Log.error("Cannot find a Zabbix host named #{new_resource.name}")
    return
  end
  
  self.zabbix_trigger = Rubix::Trigger.find(:host_id => self.zabbix_host.id, :description => new_resource.name) || Rubix::Trigger.new(:host_id => self.zabbix_host.id, :description => new_resource.name, :expression => new_resource.expression, :enabled => new_resource.enabled)
  self.zabbix_trigger.enabled = new_resource.enabled
  self.zabbix_trigger.expression = new_resource.expression unless new_resource.expression.empty?
  self.zabbix_trigger.priority   = new_resource.priority
  self.zabbix_trigger.comments   = new_resource.comments
end
