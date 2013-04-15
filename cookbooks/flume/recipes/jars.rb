%w[commons-io-1.3.2.jar json-20090211.jar mysql-connector-java-5.1.18-bin.jar].each do |jarname|
  cookbook_file "#{node[:flume][:home_dir]}/lib/#{jarname}" do
    source jarname
    owner "flume"
    mode  "0644"
  end
end
