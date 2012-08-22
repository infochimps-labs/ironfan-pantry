include_recipe 'flume'
include_recipe 'runit'

node[:flume][:multi_agent][:count].times.map do |index| 
  
  log_dir = File.join(node[:flume][:multi_agent][:log_dir_prefix], "agent_#{index}")

  directory log_dir do
    action        :create
    owner         node[:flume][:user]
    group         node[:flume][:group]
    mode          '0755'
  end
    
  #
  # Create service
  #
  runit_service "flume_agent_#{index}" do
    run_state         node[:flume][:agent][:run_state]
    template_name     'flume_multi_agent'
    log_template_name 'flume_multi_agent'
    subscribes        :restart, resources(:template => [ 
                                                        File.join(node[:flume][:conf_dir], "flume-site.xml"), 
                                                        File.join(node[:flume][:home_dir], "bin/flume-env.sh") 
                                                        ])
    options           Mash.new().merge(node[:flume]).merge(node[:flume][:agent]).
      merge({
              :service_command => 'node',
              :log_dir         => log_dir,
              :daemon_index    => index,
            })
  end

  #
  # Announce flume agent capability
  #
  announce(:flume, :agent, {
             :logs    => {
               :node    => { :glob => File.join(log_dir, 'flume-flume-node*.log'), :logrotate => false, :archive => false } },
             :ports   => {
               :status  => { :port => 35862 + index, :protocol => 'http', :dashboard => true }  },
             :daemons => {
               :java    => { :name => 'java', :cmd => 'FlumeNode' } },
           })
  
end
