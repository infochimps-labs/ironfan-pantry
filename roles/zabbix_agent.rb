name "zabbix_agent"
description "Sets up a Zabbix agent that can report data to a central Zabbix server"

run_list([
    "zabbix",
    "zabbix::agent"
])

override_attributes({
})
