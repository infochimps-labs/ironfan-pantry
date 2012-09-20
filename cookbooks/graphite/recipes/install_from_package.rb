python_pip 'whisper' do
  action        :install
  version       default[:graphite][:whisper  ][:version]
end

python_pip 'carbon' do
  action        :install
  version       default[:graphite][:carbon   ][:version]
  options       :install_option => ["--prefix=#{default[:graphite][:home_dir]}", "--install-lib=#{default[:graphite][:home_dir]}/lib"]
end

python_pip 'graphite-web' do
  action        :install
  version       default[:graphite][:dashboard][:version]
  options       :install_option => ["--prefix=#{default[:graphite][:home_dir]}", "--install-lib=#{default[:graphite][:home_dir]}/webapp"]
end
