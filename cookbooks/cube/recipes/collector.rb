dns_name = (node[:cube][:collector][:dns_name]) rescue node[:public_ip]

node[:cube][:collector][:instances].times do |idx|
  announce(:cube, :"collector_#{idx}",
           :logs    => {:collector => node[:cube][:collector][:log_dir] + "_#{idx}" },
           :ports   => {:http => { :port => node[:cube][:collector][:http_port].to_i + idx, :protocol => 'http' } },
           :daemons => {:http => { :name => 'node', :user => node[:cube][:user], :cmd => 'collector' } },
           :dns_name => dns_name )

  options = Mash.new()
  options.merge!(node[:cube])
  options.merge!(node[:cube][:collector])
  options.merge!({
    port: node[:cube][:collector][:http_port].to_i + idx,
    idx:  idx
  })

  runit_service "cube_collector_#{idx}" do
    options       options
    template_name "cube_collector"
  end
end
