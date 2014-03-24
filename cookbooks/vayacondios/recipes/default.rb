# Vayacondios log storage on a single scratch dir 	
volume_dirs('vayacondios.log') do
  type          :local
  selects       :single
  path          'vayacondios/log'
  group         'www-data'
  mode          "0777"
end
link "/var/log/vayacondios" do
  to node[:vayacondios][:log_dir]
end 
