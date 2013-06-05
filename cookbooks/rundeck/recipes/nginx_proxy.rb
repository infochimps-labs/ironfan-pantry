include_recipe 'nginx'

standard_dirs('rundeck.web') do
  user        node[:nginx][:user]
  group       node[:nginx][:group]
  directories :log_dir
end

template "/etc/nginx/sites-available/rundeck.conf" do
  source 'nginx.conf.erb'
  action :create
end

nginx_site 'rundeck.conf' do
  action   :enable
  notifies :restart, :service => 'nginx'
end
