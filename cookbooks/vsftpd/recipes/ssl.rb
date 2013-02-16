cookbook_file "#{node[:vsftpd][:ssl_cert_path]}/#{node[:vsftpd][:ssl_cert_name]}.pem" do
  cookbook node[:vsftpd][:ssl_cert_cookbook]
  owner 'root'
  group 'root'
  mode 0600
end

cookbook_file "#{node[:vsftpd][:ssl_private_key_path]}/#{node[:vsftpd][:ssl_cert_name]}.key" do
  cookbook node[:vsftpd][:ssl_cert_cookbook]
  owner 'root'
  group 'root'
  mode 0600
end
