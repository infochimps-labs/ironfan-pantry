announce(:cube, :warmer,
         :logs    => {:warmer => node[:cube][:log_dir] },
         :daemons => {:http => { :name => 'node', :user => node[:cube][:user], :cmd => 'warmer' } })

runit_service "cube_warmer" do
  options       Mash.new().merge(node[:cube]).merge(node[:cube][:warmer])
end