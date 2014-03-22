define :set_ftp_loader, thenode: nil, code_directory: '/usr/local/share/kafka-contrib/current/', command: 'bundle exec ruby scripts/ftp2s3.rb' do

  thenode = params[:thenode]

  template thenode[:config_file] do
    source "ftp2s3.yaml.erb"
    owner "root"
    mode "0644"
    variables({:config => thenode})
  end



  paths = thenode[:input_directory].split("/").reject(&:empty?)
  exploded = paths.each_with_index.map{|x,i| "/" + paths[0..i].join("/"); }
  exploded.each do |path|
    directory path do
      owner  "root"
      group  "root"
      mode   0666
      action :create
    end
  end


  paths = thenode[:output_directory].split("/").reject(&:empty?)
  exploded = paths.each_with_index.map{|x,i| "/" + paths[0..i].join("/"); }
  exploded.each do |path|
    directory path do
      owner  "root"
      group  "root"
      mode   0666
      action :create
    end
  end


  paths = thenode[:meta_directory].split("/").reject(&:empty?)
  exploded = paths.each_with_index.map{|x,i| "/" + paths[0..i].join("/"); }
  exploded.each do |path|
    directory path do
      owner  "root"
      group  "root"
      mode   0666
      action :create
    end
  end

  cron 'FTP Loader' do
    minute thenode[:interval_minutes]
    user thenode[:user]

    command "cd #{params[:code_directory]} && #{params[:command]} #{thenode[:config_file]} >> #{thenode[:log_file]}"
  end



end
