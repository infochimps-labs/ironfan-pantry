# Shorthand for deploying a descendent of ironfan-homebase, so that it 
#   may be used to test Ironfan deployment

define(:ironfan_homebase,
  :user         => nil,         # User to clone as
  :group        => nil,         # Group to clone as
  :path         => nil,         # Path to clone to
  :repository   => nil          # Repository to clone from
  ) do

  defaults              = {}
  defaults[:user]       = node[:jenkins_integration][:user]
  defaults[:group]      = node[:jenkins_integration][:group]
  defaults[:path]       = node[:jenkins_integration][:ironfan_homebase][:path] + '/' + params[:name]
  defaults[:repository] = node[:jenkins_integration][:ironfan_homebase][:repository]
  config                = defaults.merge(params)

  git_private_repo params[:name] do
    path                   config[:path]
    repository             config[:repository]
#     private_keys_contents  node[:ironfan_api][:homebase][:private_keys]
    action                 :sync
    enable_submodules      true
  end
end
