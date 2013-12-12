package("impala")
package("impala-server")

metastore   = discover(:hive, :metastore)
state_store = discover(:impala, :state_store)

template_variables = {
  :hive   => node[:hive],
  :impala => node[:impala],
  :hadoop => node[:hadoop],
  :hue    => node[:hue],
  :state_store => { :host => state_store ? state_store.private_ip : nil },
  :metastore =>   { :host => metastore   ? metastore.private_ip   : nil }
}

volume_dirs('impala.server.log') do
  type          :local
  selects       :single
  path          'hadoop/log/impala/server'
  group         'impala'
  mode          "0777"
end

runit_service "impala_server" do
  action node[:impala][:server][:run_state]
  options template_variables
end

announce(:impala, :server, {
           :logs => { :server => node[:impala][:server][:log_dir] + '/current' },
           :daemons => {
             :server => {
               :name => 'java',
               :user => node[:impala][:user],
               :cmd  => 'impalad'
             }
           }
         })
