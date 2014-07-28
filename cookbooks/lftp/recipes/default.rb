case node[:platform]
when "gentoo"
  package "net-ftp/lftp"

when "debian", "ubuntu" 
  package "lftp"

when "mac_os_x"
  package "lftp"

when 'centos', 'redhat'
  package 'lftp'
end

directory "#{node[:homedir]}/.lftp" do
  mode "0700"
end

bookmarks = []

node[:lftp][:bookmarks].each do |name, url|
  bookmarks << "#{name} #{url}"
end

file "#{node[:homedir]}/.lftp/bookmarks" do
  content bookmarks.join("\n")
  mode "0600"
end

template node[:lftp][:configfile] do
  source "lftp.conf"
  mode "0644"
end
