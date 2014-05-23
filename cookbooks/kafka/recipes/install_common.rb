standard_dirs 'kafka' do
  directories [:home_dir, :log_dir, :conf_dir, :pid_dir]
end

# sets node[:kafka][:journal_dir]
volume_dirs('kafka.journal') do
  type          :persistent
  selects       :single
  path          'kafka/journal'
end

# grab the zookeeper nodes that are currently available
zookeeper_pairs = discover_all(:zookeeper, :server).map(&:private_ip).sort.map do |ip|
  # Transform IPs to ZK strings. e.g. 12.34.56.78:2181
  "#{ip}:#{node[:zookeeper][:client_port]}"
end

%w[server.properties log4j.properties].each do |template_file|
  template "#{node[:kafka][:conf_dir]}/#{template_file}" do
    source	"#{template_file}.erb"
    owner node[:kafka][:user]
    group node[:kafka][:group]
    mode  00755
    variables({
      :kafka => Mash.new(node[:kafka].to_hash),
      :zookeeper_pairs => zookeeper_pairs.join(','),
      :client_port => node[:zookeeper][:client_port]
    })
  end
end
