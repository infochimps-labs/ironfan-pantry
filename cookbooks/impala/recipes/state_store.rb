package 'impala-state-store'

# Impala log storage on a single scratch dir
volume_dirs('impala.state_store.log') do
  type          :local
  selects       :single
  path          'impala/log/state_store'
  user          node[:impala][:user]
  group         node[:impala][:group]
  mode          '0777'
end

runit_service 'impala_state_store' do
  action  node[:impala][:state_store][:run_state]
  options(node[:impala])
end

announce(:impala, :state_store, {
  logs: { state_store: File.join(node[:impala][:state_store][:log_dir], 'current') },
  daemons: {
    state_store: {
      name: 'statestored',
      user: node[:impala][:user],
      cmd:  'statestored'
    }
  }
})
