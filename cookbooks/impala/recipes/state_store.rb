package("impala")
package("impala-state-store")

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

# Impala log storage on a single scratch dir
volume_dirs('impala.state_store.log') do
  type          :local
  selects       :single
  path          'hadoop/log/impala/state_store'
  group         'impala'
  mode          "0777"
end

runit_service "impala_state_store" do
  action node[:impala][:state_store][:run_state]
  options template_variables
end

announce(:impala, :state_store, {
           :logs => { :state_store => node[:impala][:state_store][:log_dir] + '/current' },
           :daemons => {
             :state_store => {
               :name => 'java',
               :user => node[:impala][:user],
               :cmd  => 'statestored'
             }
           }
         })
