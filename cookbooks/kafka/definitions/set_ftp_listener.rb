define :set_ftp_loader, thenode: nil, code_directory: '/usr/local/share/kafka-contrib/current/', command: 'bundle exec ruby scripts/ftp2s3.rb' do

  thenode = params[:thenode]
  conf_dir = node[:kafka][:ftp_loader][:conf_dir]
  config_file = File.join(conf_dir, "#{thenode[:name]}.yaml")
  unix_user = 'root'
  ftp_loader_path = '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin'

  directory conf_dir do
    recursive true
  end
  
  template config_file do
    source "ftp2s3.yaml.erb"
    owner "root"
    mode "0644"
    variables({:config => thenode})
  end

  directory thenode[:input_directory] do
    owner unix_user
    recursive true
    mode 0700
  end

  directory thenode[:output_directory] do
    owner unix_user
    recursive true
    mode 0700
  end

  directory thenode[:meta_directory] do
    owner unix_user
    recursive true
    mode 0700
  end

  file thenode[:log_file] do
    owner unix_user
    action :touch
    mode 0644
  end

  cron "FTP Loader #{thenode[:name]}" do
    minute '*/' + thenode[:interval_minutes]
    user unix_user

    # This doesn't appear to work. not sure what I'm doing wrong... -- josh
    path ftp_loader_path

    command "PATH=#{ftp_loader_path} bash -l -c 'cd #{params[:code_directory]} && PATH=#{ftp_loader_path} #{params[:command]} #{config_file} 2>&1 | PATH=#{ftp_loader_path} cat >> #{thenode[:log_file]}'"
  end

  announce(:ftp, :listener, logs: { main: thenode[:log_file] })
end
