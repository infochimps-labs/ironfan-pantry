#
# Tunables
#

default[:jenkins][:server][:java_heap_size_max] = 384

#"Usage"
#  "Utilize this worker as much as possible" -> "normal"
#  "Leave this machine for tied jobs only"  -> "exclusive"
default[:jenkins][:worker][:mode] = "normal"
#"# of executors"
default[:jenkins][:worker][:executors] = 1

#"Launch method"
#  "Launch worker agents via JNLP"                        -> "jnlp"
#  "Launch worker via execution of command on the Master" -> "command"
#  "Launch worker agents on Unix machines via SSH"         -> "ssh"
if node[:os] == "windows"
  default[:jenkins][:worker][:launcher] = "jnlp"
else
  default[:jenkins][:worker][:launcher] = "ssh"
end

#"Availability"
#  "Keep this worker on-line as much as possible"                   -> "always"
#  "Take this worker on-line when in demand and off-line when idle" -> "demand"
default[:jenkins][:worker][:availability] = "always"

#  "In demand delay"
default[:jenkins][:worker][:in_demand_delay] = 0
#  "Idle delay"
default[:jenkins][:worker][:idle_delay] = 1

#"Node Properties"
#[x] "Environment Variables"
default[:jenkins][:worker][:env] = nil
