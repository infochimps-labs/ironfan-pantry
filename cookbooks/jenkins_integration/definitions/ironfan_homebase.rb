# Shorthand for deploying a descendent of ironfan-homebase, so that it 
#   may be used to

define(:ironfan_homebase,
  :path         => node[:jenkins_integration][:ironfan_homebase][:path]
#   :action       => [:create, :manage],  # action. You typically want [:create, :manage] or [:create]
#   :user         => nil,                 # username to create.      default: `scoped_hash[:user]`
#   :home         => nil,                 # home directory for daemon. default: `scoped_hash[:pid_dir]`
#   :manage_home  => false,               # manage home directory? set to false, because most daemon users should not own their own home
#   :shell        => '/bin/false',        # shell to set. default: `/bin/false`
#   :group        => nil,                 # group for daemon.          default: `scoped_hash[:group]`
#   :comment      => nil,                 # comment for user info
#   :create_group => true                 # Action to take on the group: `true` means `[:create]`, false-y means do nothing, or you can supply explicit actions (eg `[:create, :manage]`). default: true
  ) do

  git_private_repo params[:name] do
    path                   params[:path]
#     repository             node[:ironfan_api][:homebase][:git_url]
#     private_keys_contents  node[:ironfan_api][:homebase][:private_keys]
#     action                 :sync
#     enable_submodules      true
  end
#   sys, subsys = params[:name].to_s.split(".", 2).map(&:to_sym)
#   component = Ironfan::Component.new(node, sys, subsys)
#
#   params[:user]         ||= (component.node_attr(:user, :required) || params[:name] )
#   params[:group]        ||= (component.node_attr(:group) || params[:user])
#   params[:home]         ||= component.node_attr(:pid_dir, :required)
#   params[:comment]      ||= "#{component.name} daemon"
#   #
#   user_val                = params[:user].to_s
#   group_val               = params[:group].to_s
#   uid_val                 = node[:users ][user_val ] && node[:users ][user_val ][:uid] rescue nil
#   gid_val                 = node[:groups][group_val] && node[:groups][group_val][:gid] rescue nil
#
#   params[:create_group]   = [:create] if (params[:create_group] == true)
#   params[:create_group]   = false     if (group_val == 'nogroup')
#
#   #
#   # Make the group
#   #
#   if params[:create_group]
#     group group_val do
#       gid       gid_val
#       action    params[:create_group]
#     end
#   end
#
#   #
#   # Make the home_dir's parent directory if we're managing home
#   #
#   if params[:manage_home]
#     directory File.dirname(params[:home]) do
#       action    :create
#       recursive true
#     end
#   end
#
#   #
#   # Make the user
#   #
#   user user_val do
#     uid         uid_val
#     gid         group_val
#     password    nil
#     shell       params[:shell]
#     home        params[:home]
#     supports    :manage_home => params[:manage_home]
#     action      params[:action]
#   end
end
