standard_dirs(:rundeck) do
  directories :home_dir, :data_dir, :conf_dir, :log_dir, :pid_dir # pid_dir created by daemon_user above
end

# Rundeck log storage on a single scratch dir
volume_dirs('rundeck.log') do
  type          :local
  selects       :single
  path          'rundeck/log'
  group         'rundeck'
  mode          "0777"
end
link "/var/log/rundeck" do
  to node[:rundeck][:log_dir]
end

volume_dirs('rundeck.chef_rundeck.log') do
  type          :local
  selects       :single
  path          'rundeck/log/chef_rundeck'
  group         'rundeck'
  mode          "0777"
end

volume_dirs('rundeck.web.log') do
  type          :local
  selects       :single
  path          'rundeck/log/web'
  group         'rundeck'
  mode          "0777"
end