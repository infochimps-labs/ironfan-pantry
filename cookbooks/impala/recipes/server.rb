package 'impala-server'

volume_dirs('impala.server.log') do
  type          :local
  selects       :single
  path          'impala/log/server'
  owner         node[:impala][:user]
  group         node[:impala][:group]
  mode          '0777'
end

runit_service 'impala_server' do
  action  node[:impala][:server][:run_state]
  options(node[:impala])
end

announce(:impala, :server, {
  logs: { server: File.join(node[:impala][:server][:log_dir], 'current') },
  daemons: {
    server: {
      name: 'impalad',
      user: node[:impala][:user],
      cmd:  'impalad'
    }
  }
})
