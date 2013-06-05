conf_dir = node[:cluster_directory][:conf_dir]

directory(conf_dir) do
  mode "0755"
  action :create
end

kafka_ips = discover_all(:kafka, :server).map(&:private_ip)

template File.join(conf_dir, 'cluster_directory.yaml') do
  variables     :kafka_ips => kafka_ips
  mode          "0644"
end
