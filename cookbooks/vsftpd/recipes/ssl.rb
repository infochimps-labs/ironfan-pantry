if node[:vsftpd][:ssl_enable]
  
  node.default[:vsftpd][:ssl_cert_path] = File.join(node[:vsftpd][:conf_dir], 'vsftpd.pem')

  if node[:vsftpd][:ssl_cert]
    file node[:vsftpd][:ssl_cert_path] do
      owner   'root'
      group   'root'
      mode    '0600'
      action  :create
      content node[:vsftpd][:ssl_cert]
    end
  else
    remote_file node[:vsftpd][:ssl_cert_path] do
      owner   'root'
      group   'root'
      mode    '0600'
      action  :create
      source  'file://ftp.example.com.pem'
    end
  end

  if node[:vsftpd][:ssl_private_key]
    node.default[:vsftpd][:ssl_private_key_path] = File.join(node[:vsftpd][:conf_dir], 'vsftpd.key')
    remote_file node[:vsftpd][:ssl_private_key_path] do
      owner   'root'
      group   'root'
      mode    '0600'
      action  :create
      source  "ftp.example.com.key"
      content node[:vsftpd][:ssl_private_key]
    end
  end
end
