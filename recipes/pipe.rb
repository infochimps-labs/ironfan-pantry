%w[rubix configliere].each { |name| gem_package(name) }

bash "create /dev/zabbix pipe" do
  code "sudo mkfifo /dev/zabbix && chown zabbix:admin /dev/zabbix && chmod 666 /dev/zabbix"
  not_if { File.exist?('/dev/zabbix') }
end

runit_service "zabbix_pipe"

announce(:zabbix, :pipe, :logs => { :pipe => '/etc/sv/zabbix_pipe/log/main/current' }, :daemons => { :pipe => 'zabbix_pipe' })
