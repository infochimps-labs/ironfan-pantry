mongo = discover(:mongodb, :server)

template File.join(node[:vayacondios][:conf_dir], "vayacondios.yaml") do 
  source    "vayacondios.yaml.erb"
  mode      "0644"
  action    :create
  notifies(:restart, "service[vayacondios]", :delayed)
  variables({
    :mongodb  => { :host => mongo.private_ip },
    :vayacondios  => {
       :host => "127.0.0.1",
       :port => node[:vayacondios][:goliath][:port],
       :legacy_mode => node[:vayacondios][:legacy_mode],
    },
  })
end
