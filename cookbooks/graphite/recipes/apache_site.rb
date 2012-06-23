include_recipe 'apache2::mod_python'

template "#{node[:apache][:dir]}/sites-available/graphite.conf" do
  mode          0644
  variables     :web_dir => dashboard_dir,
                :log_dir => node[:graphite][:log_dir]
  source        "graphite-vhost.conf.erb"
end

apache_site "000-default" do
  enable        false
end

apache_site "graphite.conf"
