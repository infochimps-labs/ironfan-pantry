name        'flume_agent'
description 'flume agent'

run_list(*%w[
  flume
  flume::jars
  flume::plugin-hbase_sink
  flume::agent
  flume::config_files
  flume_integration::jruby
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
