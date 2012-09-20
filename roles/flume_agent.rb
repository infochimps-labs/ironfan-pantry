name        'flume_agent'
description 'flume agent'

run_list(*%w[
  flume
  flume::install_from_package
  flume::make_dirs
  flume::jars
  role[maven]
  flume::plugin-hbase_sink

  flume::agent

  flume_integration::default
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
