name        "org_final"
description "[internal] Further cookbooks and internal recipes applied at the end of a run (using :last). Applied to EVERY node in the organization."

# List of recipes and roles to apply
# run_list(*(%w[
#   rundeck::client
#   zabbix::client
# ]))

default_attributes({
  })
