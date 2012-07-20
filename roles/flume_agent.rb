name        'flume_agent'
description 'flume agent'

run_list(*%w[
  flume
  flume::jars
  flume::plugin-hbase_sink
  role[maven]
  flume::plugin-ics_helpers
  flume::agent
  flume_integration::jruby_classpath
  flume::config_files
  flume_integration::jruby_home
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
