standard_dirs(:rundeck) do
  directories :home_dir, :data_dir, :conf_dir, :log_dir, :pid_dir # pid_dir created by daemon_user above
end
