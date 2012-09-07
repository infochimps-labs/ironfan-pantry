# == Users

# setup kafka group
group node[:kafka][:group] do
end

# setup kafka user
user node[:kafka][:user] do
  comment "Kafka user"
  gid "kafka"
  home "/home/kafka"
  shell "/bin/noshell"
  supports :manage_home => false
end

