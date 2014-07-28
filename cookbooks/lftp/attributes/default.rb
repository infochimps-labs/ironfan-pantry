case node[:platform]
  when "gentoo"
    default[:lftp][:configfile] = "/etc/lftp/lftp.conf"
  when "debian", "ubuntu" 
    default[:lftp][:configfile] = "/etc/lftp.conf"
  when "centos", "redhat"
    default[:lftp][:configfile] = "/etc/lftp.conf"
end

default[:lftp][:bookmarks] = {}
