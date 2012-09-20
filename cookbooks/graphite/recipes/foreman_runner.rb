#
# Installs a procfile runner
#

gem_package 'foreman'

template "#{node[:graphite][:conf_dir]}/Procfile" do
  mode          "0644"
  variables     :graphite => Mash.new.merge(node[:graphite])
  source        "foreman_Procfile.erb"
end

template "#{node[:graphite][:conf_dir]}/.env" do
  mode          "0644"
  variables     :graphite => Mash.new.merge(node[:graphite])
  source        "foreman_dot_env.erb"
end
