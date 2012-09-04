# create the log directory
directory "#{node[:kafka][:log_dir]}" do
  owner   node[:kafka][:user]
  group   node[:kafka][:group]
  mode    00755
  recursive true
  action :create
end

# create the data directory
directory "#{node[:kafka][:data_dir]}" do
  owner   node[:kafka][:user]
  group   node[:kafka][:group]
  mode    00755
  recursive true
  action :create
end

