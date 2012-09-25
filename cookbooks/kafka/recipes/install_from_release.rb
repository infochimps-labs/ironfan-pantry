include_recipe 'install_from'

# pull the remote file only if we create the directory
tarball = "kafka-#{node[:kafka][:version]}-src.tgz"
download_file = File.join("#{node[:kafka][:download_url]}", "#{tarball}")

remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
  source download_file
  mode 00644
  action :create_if_missing
end

install_from_release(:kafka) do
  release_url download_file
  home_dir node[:kafka][:install_dir]
  version node[:kafka][:version]
  checksum node[:kafka][:checksum]
  action [ :build_with_sbt, :install ]
end

template "#{node[:kafka][:install_dir]}/bin/service-control" do
  source  "service-control.erb"
  owner "root"
  group "root"
  mode  00755
  variables({
        :install_dir => node[:kafka][:install_dir],
	:log_dir => node[:kafka][:log_dir], 
        :java_home => node['java']['java_home'],
        :java_jmx_port => 9999,
        :java_class => "kafka.Kafka",
        :user => node[:kafka][:user]
  })
end

# grab the zookeeper nodes that are currently available
zookeeper_pairs = discover_all(:zookeeper, :server).map(&:private_ip).sort.map{|x| "#{x}:#{node[:zookeeper][:client_port]}"}
kafka_chroot_suffix = node[:kafka][:chroot_suffix]

%w[server.properties log4j.properties].each do |template_file|
    template "#{node[:kafka][:install_dir]}/config/#{template_file}" do
        source	"#{template_file}.erb"
        owner node[:kafka][:user]
        group node[:kafka][:group]
        mode  00755
        variables({ 
            :kafka => node[:kafka],
            :zookeeper_pairs => zookeeper_pairs,
            :client_port => node[:zookeeper][:client_port]
        })
    end
end

# fix perms and ownership
execute "chmod" do
	command "find #{node[:kafka][:install_dir]} -name bin -prune -o -type f -exec chmod 644 {} \\; && find #{node[:kafka][:install_dir]} -type d -exec chmod 755 {} \\;"
	action :run
end
execute "chown" do
	command "chown -R root:root #{node[:kafka][:install_dir]}"
	action :run
end
execute "chmod" do
	command "chmod -R 755 #{node[:kafka][:install_dir]}/bin"
	action :run
end

# delete the application tarball
execute "delete_install_source" do
    user "root"
    group "root"
    command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
    action :run
end
