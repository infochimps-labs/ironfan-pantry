# To integrate with other services, Cube needs to publish a stable name, so that they can all share cookies
dns_name = (node[:cube][:evaluator][:dns_name]) rescue node[:public_ip]
announce(:cube, :evaluator,
         :logs     => {:evaluator => node[:cube][:log_dir] },
         :ports    => {:http => { :port => node[:cube][:evaluator][:http_port], :protocol => 'http' } },
         :daemons  => {:http => { :name => 'node', :user => node[:cube][:user], :cmd => 'evaluator' } },
         :dns_name => dns_name )

runit_service "cube_evaluator" do
  options       Mash.new().merge(node[:cube]).merge(node[:cube][:evaluator])
end
