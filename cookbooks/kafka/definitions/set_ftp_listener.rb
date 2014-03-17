define :set_ftp_loader, thenode: nil, code_directory: '/usr/local/share/kafka-contrib/current/', command: 'bundle exec ruby scripts/ftp2s3.rb' do
  
  thenode = params[:thenode]


  template thenode[:config_file] do
    source "ftp2s3.yaml.erb"
    owner "root"
    mode "0644"
    variables({:config => thenode})
  end

  cron 'FTP Loader' do
    minute thenode[:interval_minutes]
    user thenode[:user]

    command "cd #{params[:code_directory]} && #{params[:command]} #{thenode[:config_file]} >> #{thenode[:log_file]}"
  end



end
