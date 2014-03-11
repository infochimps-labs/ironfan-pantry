include_recipe "runit"

# FIXME does this have all the right perms and stuff?
# standard_dirs 'kafka' do
#   directories [:journal_dir]
# end

# create the runit service
runit_service "kafka" do
  run_state node[:kafka][:server][:run_state]
  options({
    # TODO symlink /var/log/kafka/kafka.log or whatever (CLEANUP)
    :log_dir => node[:kafka][:log_dir],
    :home_dir => node[:kafka][:home_dir],
    :journal_dir => node[:kafka][:journal_dir],
    :install_dir => node[:kafka][:install_dir],
    :java_home => node[:java][:java_home],
    :java_jmx_port => node[:kafka][:jmx_port],
    :java_class => 'kafka.Kafka',
    :user => node[:kafka][:user]
  }) 
end

announce(:kafka, :server, {
  :logs => { :kafka => { :path => "#{node[:kafka][:log_dir]}/kafka.log" } },
  :ports => { :server => node[:kafka][:port] },
  :daemons => {
    :kafka => { :user => node[:kafka][:user], :name => 'java'},
  },
})
