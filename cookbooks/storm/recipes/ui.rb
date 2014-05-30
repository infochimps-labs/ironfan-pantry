daemon_user 'storm.ui'

standard_dirs 'storm.ui' do
  directories [:home_dir, :log_dir]
end

runit_service 'storm_ui' do
  run_state     node[:storm][:ui][:run_state]
  options       Mash.new(node[:storm].to_hash).merge(node[:storm][:ui].to_hash)
end

announce(:storm, :ui, {
  logs: {
    storm: node[:storm][:log_path_ui]
  },
  daemons: {
    # FIXME: Zabbix can't tell Nimbus process from the UI process
    storm_ui: {
      name: 'java',
      user: node[:storm][:user],
      cmd:  'backtype.storm.ui.core'
    }
  }
})
