include Chef::RubixConnection

action :create do
  log(zabbix_action.inspect) do
    level :info
  end
  zabbix_action.save if connected_to_zabbix? && zabbix_action
end

action :destroy do
  zabbix_action.destroy if connected_to_zabbix? && zabbix_action
end

attr_accessor :zabbix_action

def load_current_resource
  return unless connect_to_zabbix_server(new_resource.server)
  begin
    self.zabbix_action           = (Rubix::Action.find(:name => new_resource.name) || Rubix::Action.new(:name => new_resource.name))
    self.zabbix_action.event_source             = new_resource.event_source
    self.zabbix_action.escalation_time          = new_resource.escalation_time
    self.zabbix_action.message_subject          = new_resource.message_subject
    self.zabbix_action.message_body             = new_resource.message_body
    self.zabbix_action.send_recovery_message    = new_resource.send_recovery_message
    self.zabbix_action.recovery_message_subject = new_resource.recovery_message_subject
    self.zabbix_action.recovery_message_body    = new_resource.recovery_message_body
    if new_resource.conditions && (!new_resource.conditions.empty?)
      self.zabbix_action.conditions               = new_resource.conditions
    end
    self.zabbix_action.condition_operator       = new_resource.condition_operator
    if new_resource.operations && (!new_resource.operations.empty?)
      self.zabbix_action.operations = new_resource.operations.map do |operation|
        operation = operation.dup
        case
        when operation.has_key?(:user_group_name)
          group = Rubix::UserGroup.find(:name => operation[:user_group_name])
          if group
            operation[:user_group] = group
            operation
          else
            ::Chef::Log.warn("Could not find a user group named '#{operation[:user_group_name]}', skipping adding operation to action '#{new_resource.name}'...")
            nil
          end
        when operation.has_key?(:username)
          user = Rubix::User.find(:username => operation[:username])
          if user
            operation[:user] = user
            operation
          else
            ::Chef::Log.warn("Could not find a user named '#{operation[:username]}', skipping adding operation to action '#{new_resource.name}'...")
            nil
          end
        else
          ::Chef::Log.warn("Did not declare either a user or a user group, skipping adding operation to action '#{new_resource.name}'...")
          nil
        end
      end.compact
    end
  rescue ArgumentError, ::Rubix::Error, ::Errno::ECONNREFUSED => e
    ::Chef::Log.warn("Could not initialize Zabbix action #{new_resource.name}: #{e.message}")
  end
end
