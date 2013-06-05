if node[:kafka][:broker_id].nil? || node[:kafka][:broker_id] == ''
  # 10.01.02.03 => (((01 << 8) + 02) << 8) + 03
  node.set[:kafka][:broker_id] = node[:ipaddress].split(".").map(&:to_i).to_a[1..-1].
    inject(0){|sum, x| (sum << 8) + x}
end

node.set[:kafka][:broker_host_name] = node[:fqdn]

Chef::Log.info "Kafka broker id: #{node[:kafka][:broker_id]}"
Chef::Log.info "Kafka broker name: #{node[:kafka][:broker_host_name]}"

