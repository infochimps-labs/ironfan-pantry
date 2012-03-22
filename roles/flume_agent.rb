name        'flume_agent'
description 'flume agent'

run_list(*%w[
  flume
  flume::plugin-hbase_sink
  flume::plugin-jruby
  flume::agent
  flume::config_files
])

override_attributes({
  :zabbix => {
    :host_groups => {
      :flume => ['Flume nodes'],
    },
    :templates   => {
      :flume => ['Template_Flume_Node']
    }
  }
})
