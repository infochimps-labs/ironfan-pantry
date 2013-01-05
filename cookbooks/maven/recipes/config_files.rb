directory node[:maven][:conf_dir] do
    owner "root"
    group "root"
    mode "0755"
    recursive true
end

template "#{node[:maven][:conf_dir]}/settings.xml" do
    owner "root"
    group "root"
    mode "0644"
    variables(:aws_access_key        => node[:aws][:aws_access_key],
              :aws_secret_access_key => node[:aws][:aws_secret_access_key])
    source "settings.xml.erb"
end
