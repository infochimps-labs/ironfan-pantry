#include_recipe 'nodejs::compile'

daemon_user(:cube) do
  manage_home   false
  create_group  true
end

standard_dirs "cube.evaluator" do
  directories :log_dir
end
standard_dirs "cube.warmer" do
  directories :log_dir
end

node[:cube][:collector][:instances].times do |idx|
  directory node[:cube][:collector][:log_dir] + "_#{idx}" do
    owner       node[:cube][:user]
    group       node[:cube][:group]
    mode        '0775'
    action      :create
    recursive   true
  end
end

standard_dirs "cube" do
 # do *not* include home_dir as it is actually a symlink that will be
 # created by the deploy_revision block below
 directories :deploy_root, :log_dir, :pid_dir, :conf_dir, :tmp_dir
end
