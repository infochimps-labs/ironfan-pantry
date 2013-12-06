package("hive")
package("hive-metastore")

# Hive log storage on a single scratch dir
volume_dirs('hive.metastore.log') do
  type          :local
  selects       :single
  path          'hadoop/log/hive/metastore'
  group         'hive'
  mode          "0777"
end

runit_service "hive_metastore" do
  action node[:hive][:metastore][:run_state]
end

announce(:hive, :metastore, {
           :logs => { :metastore => node[:hive][:metastore][:log_dir] + '/current' },
           :daemons => {
             :metastore => {
               :name => 'java',
               :user => node[:hive][:user],
               :cmd  => 'org.apache.hadoop.hive.metastore.HiveMetaStore'
             }
           }
         })
