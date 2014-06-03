package 'impala-catalog'

# Impala log storage on a single scratch dir
volume_dirs('impala.catalog.log') do
  type          :local
  selects       :single
  path          'impala/log/catalog'
  user          node[:impala][:user]
  group         node[:impala][:group]
  mode          '0777'
end

runit_service 'impala_catalog' do
  action  node[:impala][:catalog][:run_state]
  options(node[:impala])
end

announce(:impala, :catalog, {
  logs: { state_store: File.join(node[:impala][:catalog][:log_dir], 'current') },
  daemons: {
    state_store: {
      name: 'catalogd',
      user: node[:impala][:user],
      cmd:  'catalogd'
    }
  }
})
