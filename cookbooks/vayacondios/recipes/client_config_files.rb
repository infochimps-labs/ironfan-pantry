mongo = discover(:mongodb, :server)
vayacondios = discover(:vayacondios, :server)

template File.join(node[:vayacondios][:conf_dir], "vayacondios.yaml") do 
  source    "vayacondios.yaml.erb"
  mode      "0644"
  variables({
    :mongodb  => { :host => mongo.private_ip },
    :vayacondios  => {
       :host => vayacondios.private_ip,
       :port => vayacondios.ports[:goliath][:port],
       :vayacondios_legacy_mode => vayacondios[:legacy_mode],
    },
  })
end
