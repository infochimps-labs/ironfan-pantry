package("hive")
package("hive-server2")

# Hive log storage on a single scratch dir
volume_dirs('hive.server.log') do
  type          :local
  selects       :single
  path          'hadoop/log/hive/server'
  group         'hive'
  mode          "0777"
end

runit_service "hive_server" do
  action       node[:hive][:server][:run_state]
end

announce(:hive, :server, {
           :logs => { :server => node[:hive][:server][:log_dir] + '/current' },
           :daemons => {
             :datanode => {
               :name => 'java',
               :user => node[:hive][:user],
               :cmd  => 'org.apache.hive.service.server.HiveServer'
             }
           }
         })
