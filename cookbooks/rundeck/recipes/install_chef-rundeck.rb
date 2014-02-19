standard_dirs('rundeck.chef_rundeck') do
  directories :log_dir # , :home_dir
  user        node[:rundeck][:user]
  group       node[:rundeck][:group]
end

directory node[:rundeck][:chef_rundeck][:home_dir] do
  action :create
  mode   '0755'
  user   node[:rundeck][:user]
  group  node[:rundeck][:group]
end

file "/etc/chef/client.pem" do
  group node[:rundeck][:group]
  mode  '0640'
end

bash 'Bundle install chef-rundeck' do
  code   "cd #{node[:rundeck][:chef_rundeck][:home_dir]} && bundle install --standalone --without development"
  action :nothing
end

git node[:rundeck][:chef_rundeck][:home_dir] do
  repository node[:rundeck][:chef_rundeck][:git_url]
  reference  'master'
  action     :checkout
  user       node[:rundeck][:user]
  group      node[:rundeck][:group]
  notifies :run, resources(bash: 'Bundle install chef-rundeck'), :immediately
end

runit_service "chef-rundeck"
