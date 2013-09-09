include Chef::RubixConnection

action :create do
  zabbix_item.save if connected_to_zabbix? && zabbix_item
end

action :destroy do
  zabbix_item.destroy if connected_to_zabbix? && zabbix_item
end

attr_accessor :zabbix_host, :zabbix_item

def load_current_resource
  return unless connect_to_zabbix_server(new_resource.server)
  begin
    self.zabbix_host = Rubix::Host.find(:name => new_resource.host)
    unless self.zabbix_host
      Chef::Log.error("Cannot find a Zabbix host named #{new_resource.host}")
      return
    end
    
    self.zabbix_item = Rubix::Item.find(:host_id => self.zabbix_host.id, :key => new_resource.key) || Rubix::Item.new(:host_id => self.zabbix_host.id, :key => new_resource.key)
    self.zabbix_item.description = new_resource.name
    self.zabbix_item.type        = new_resource.type
    self.zabbix_item.value_type  = new_resource.value_type
    self.zabbix_item.units       = new_resource.units
    load_applications
  rescue ArgumentError, ::Rubix::Error, ::Errno::ECONNREFUSED => e
    ::Chef::Log.warn("Could not create Zabbix item #{new_resource.key}: #{e.message}")
  end
end

def load_applications
  current_applications = self.zabbix_item.applications || []
  current_application_names = current_applications.map(&:name).to_set
  (new_resource.applications || []).flatten.compact.uniq.each do |application_name|
    next if current_application_names.include?(application_name)
    current_applications << Rubix::Application.find_or_create(:name => application_name, :host_id => self.zabbix_host.id)
    current_application_names << application_name
  end
  self.zabbix_item.applications = current_applications
end
