gem_package 'unicorn'
gem_package 'geminabox'

standard_dirs 'package_server.gem' do
  directories :home_dir, :data_dir, :log_dir, :conf_dir, :tmp_dir
end

template File.join(node[:package_server][:gem][:home_dir], 'config.ru') do
  source      'config.ru.erb'
  mode        '0664'
  owner       node[:package_server][:user]
  group       node[:package_server][:group]
end

template File.join(node[:package_server][:gem][:conf_dir], 'unicorn.rb') do
  source      'unicorn.rb.erb'
  mode        '0664'
  owner       node[:package_server][:user]
  group       node[:package_server][:group]
end

runit_service 'gem_server'

assign_dns_name :gem 

create_nginx_proxy :gem do
  proxy       node[:package_server][:gem][:fqdn]
  source      "unix:#{node[:package_server][:gem][:tmp_dir]}/unicorn.socket"
end
