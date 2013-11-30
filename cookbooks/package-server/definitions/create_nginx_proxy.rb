define :create_nginx_proxy, proxy: nil, source: nil do

  proxy_name     = params[:name]

  standard_dirs :package_server do
    user           node[:nginx][:user]
    group          node[:nginx][:group]
    directories    :log_dir
  end

  template "/etc/nginx/sites-available/#{proxy_name}.conf" do
    source         'nginx.conf.erb'
    action         :create
    variables({
      server:      params[:source],
      proxy_name:  proxy_name,
      root:        node[:package_server][proxy_name][:home_dir],
      server_name: params[:proxy],
    })
  end
  
  nginx_site "#{proxy_name}.conf" do
    action         :enable
    notifies       :restart, service: 'nginx'
  end

end
