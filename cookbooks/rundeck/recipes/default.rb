daemon_user :rundeck do
  manage_home  true             # rundeck owns this so it can manage its own SSH credentials
  shell        '/bin/bash'
  comment      'Rundeck user'
end

standard_dirs(:rundeck) do
  directories :home_dir, :data_dir, :conf_dir, :log_dir # pid_dir created by daemon_user above
end

directory File.join(node[:rundeck][:pid_dir], '.ssh') do
  mode      '0700'
  owner     node[:rundeck][:user]
  group     node[:rundeck][:group]
end

