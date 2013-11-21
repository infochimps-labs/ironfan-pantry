# Deb install creates home dir with root:rundeck ownership, ssh needs rundeck:rundeck
directory node[:rundeck][:home_dir] do
  mode      '0700'
  owner     node[:rundeck][:user]
  group     node[:rundeck][:group]
end

directory File.join(node[:rundeck][:home_dir], '.ssh') do
  mode      '0700'
  owner     node[:rundeck][:user]
  group     node[:rundeck][:group]
end
