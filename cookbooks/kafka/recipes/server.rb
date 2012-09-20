# create the runit service
runit_service "kafka" do
    options({
        :log_dir => node[:kafka][:log_dir],
        :install_dir => node[:kafka][:install_dir],
        :java_home => node['java']['java_home'],
        :user => node[:kafka][:user]
      }) 
end

announce(:kafka, :server)

#Create collectd plugin for kafka JMX objects if collectd has been applied.
if node.attribute?("collectd")
  template "#{node[:collectd][:plugin_conf_dir]}/collectd_kafka-broker.conf" do
    source "collectd_kafka-broker.conf.erb"
    owner "root"
    group "root"
    mode 00644
    notifies :restart, resources(:service => "collectd")
  end
end
