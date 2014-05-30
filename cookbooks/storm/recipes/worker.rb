standard_dirs 'storm.worker' do
  directories [:home_dir, :log_dir]
end

runit_service 'storm_worker' do
  run_state     node[:storm][:worker][:run_state]
  options       Mash.new(node[:storm].to_hash).merge(node[:storm][:worker].to_hash)
end

announce(:storm, :worker, {
  logs: {
    storm: {
      path: node[:storm][:log_path_worker],
      size: '100M'
    }
  },
  daemons: {
    # FIXME: Zabbix can't tell Nimbus process from the UI process
    storm_worker: {
      name: 'java',
      user: node[:storm][:user],
      cmd:  'backtype.storm.daemon.supervisor'
    }
  }
})
