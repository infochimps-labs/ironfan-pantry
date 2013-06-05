standard_dirs('rundeck.chef_rundeck') do
  directories :log_dir
end

file "/etc/chef/client.pem" do
  group node[:rundeck][:group]
  mode  '0640'
end

git node[:rundeck][:chef_rundeck][:home_dir] do
  repository node[:rundeck][:chef_rundeck][:git_url]
  reference  'master'
  action     :checkout
  user       node[:rundeck][:user]
  group      node[:rundeck][:group]
end

runit_service "chef-rundeck"
