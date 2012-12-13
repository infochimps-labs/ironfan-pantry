# Shorthand for deploying a descendent of ironfan-homebase, so that it 
#   may be used to test Ironfan deployment

define(:ironfan_homebase,
  :user         => nil,         # User to clone as
  :group        => nil,         # Group to clone as
  :base_path    => nil,         # Base path to clone to a subdirectory of
  :full_path    => nil,         # Path to clone to, overrides base_path
  :repository   => nil,         # Repository to clone from
  :git_keys     => nil
  ) do

  defaults              = {}
  defaults[:user]       = node[:jenkins_integration][:user]
  defaults[:group]      = node[:jenkins_integration][:group]
  defaults[:base_path]  = node[:jenkins_integration][:ironfan_homebase][:path]
  defaults[:repository] = node[:jenkins_integration][:ironfan_homebase][:repository]
  config                = defaults.merge(params)

  git_private_repo params[:name] do
    user                   config[:user]
    group                  config[:group]
    path                   config[:full_path] || "#{config[:base_path]}/#{config[:name]}"
    repository             config[:repository]
    private_keys_contents  config[:git_keys] unless config[:git_keys].nil?
    action                 :sync
    enable_submodules      true
  end

  # bundle install

  # create knife-user-testmonkey.rb, add AWS keys
  # create testmonkey.pem for Chef                      ## (do I refactor git_keys?)
end
