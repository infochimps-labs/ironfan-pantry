standard_dirs 'storm.master' do
  directories [:home_dir, :log_dir, :data_dir]
end

runit_service 'storm_master' do
  run_state   node[:storm][:master][:run_state]
  options     Mash.new(node[:storm].to_hash).merge(node[:storm][:master].to_hash)
end

announce(:storm, :master, {
  logs: {
    storm: {
      path: node[:storm][:log_path_master],
      size: '100M'
    }
  },
  daemons: {
    # FIXME: Zabbix can't tell Nimbus process from the UI process
    storm_master: {
      name: 'java',
      user: node[:storm][:user],
      cmd:  'backtype.storm.daemon.nimbus'
    }
  }
})
