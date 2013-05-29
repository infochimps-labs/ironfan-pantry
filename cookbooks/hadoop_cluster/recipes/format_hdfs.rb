bash "format HDFS namenode" do
  code "echo Y | #{node[:hadoop][:conf_dir]}/bootstrap_hadoop_namenode.sh"
  not_if { File.exists? "#{hadoop_config_hash[:namenode][:data_dirs].last}/current" }
  %w[namenode datanode secondarynn tasktracker jobtracker].each do |name|
    next if node[:hadoop][name].nil?
    next unless node[:hadoop][name][:run_state] == 'start'
    notifies :restart, "service[hadoop_#{name}]", :delayed
  end
end

