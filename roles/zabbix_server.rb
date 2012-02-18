name "zabbix_server"
description "Sets up a Zabbix server, PHP frontend, alerting scripts, and a pipe."

run_list([
    "zabbix",
    "zabbix::agent",
    "zabbix::server",
    "zabbix::database",
    "zabbix::web",
])

override_attributes({
})
