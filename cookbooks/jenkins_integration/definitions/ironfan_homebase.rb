# Shorthand for deploying a descendent of ironfan-homebase, so that it 
#   may be used to test Ironfan deployment

define(:ironfan_homebase,
  :user         => node[:jenkins_integration][:user],
  :group        => node[:jenkins_integration][:group],
  :path         => node[:jenkins_integration][:ironfan_homebase][:path] + '/' + params[:name],
  :repository   => node[:jenkins_integration][:ironfan_homebase][:repository]
  ) do

  git_private_repo params[:name] do
    path                   params[:path]
    repository             params[:repository]
#     private_keys_contents  node[:ironfan_api][:homebase][:private_keys]
    action                 :sync
    enable_submodules      true
  end
end
