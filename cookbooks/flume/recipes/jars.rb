%w[commons-io-1.3.2.jar].each do |jarname|
  cookbook_file "#{node[:flume][:home_dir]}/lib/#{jarname}" do
    source jarname
    owner "flume"
    mode  "0644"
  end
end
