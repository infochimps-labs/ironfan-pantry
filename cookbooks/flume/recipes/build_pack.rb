flume_deploy_pack @node[:customer][:name] do
  git_url "git@github.com:infochimps/#{@node[:customer][:name]-flume-deploy}.git"
end
