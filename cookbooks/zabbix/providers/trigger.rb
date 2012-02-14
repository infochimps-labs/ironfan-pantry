include ::Chef::RubixConnection

action :create do
  zabbix_trigger.save if connected_to_zabbix? && zabbix_trigger
end

action :destroy do
  zabbix_trigger.destroy if connected_to_zabbix? && zabbix_trigger
end

attr_accessor :zabbix_trigger, :zabbix_host

def load_current_resource
  return unless connect_to_zabbix_server(new_resource.server)
  begin
    self.zabbix_host   = Rubix::Host.find(:name => new_resource.host)
    unless self.zabbix_host
      Chef::Log.error("Cannot find a Zabbix host named #{new_resource.name}")
      return
    end

    self.zabbix_trigger            = (Rubix::Trigger.find(:host_id => self.zabbix_host.id, :description => new_resource.name) || Rubix::Trigger.new(:host_id => self.zabbix_host.id, :description => new_resource.name))
    self.zabbix_trigger.status     = (new_resource.enabled ? :enabled : :disabled)
    self.zabbix_trigger.expression = new_resource.expression unless new_resource.expression.empty?
    self.zabbix_trigger.priority   = new_resource.priority.to_sym
    self.zabbix_trigger.comments   = new_resource.comments
  rescue ArgumentError, ::Rubix::Error, ::Errno::ECONNREFUSED => e
    ::Chef::Log.warn("Could not create Zabbix trigger #{new_resource.name}: #{e.message}")
  end
end
