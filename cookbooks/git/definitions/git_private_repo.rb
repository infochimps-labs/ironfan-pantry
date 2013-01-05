# Clone (or setup to clone) a private git repository or one with
# private submodules.
#
# Assuming that the cookbook of the containing recipe contains an SSH
# private key named "foobar.pem" as a cookbook file, the private git
# repository "foobar" can be cloned using
#
#  git_private_repo 'foobar' do
#    repository 'git@github.com:myaccount/foobar.git'
#    path       '/var/www/foobar'
#  end
#
# The private key "foobar.pem" will be dropped into
# '/etc/deploy/foobar/foobar.pem' and an SSH wrapper for git will be
# dropped into '/etc/deploy/foobar/foobar.sh' (but see
# node[:git][:deploy_root]).
#
# The created SSH wrapper and the "branch", "repository", "user",
# "group", "action", and "enable_submodules" options will be passed to
# the usual Chef git resource.  It's important that the private
# repository be accessed via a 'git@' style URI, not a 'git://' style.
#
# Passing 'action :ssh_wrapper' will cause all all the private keys
# and the wrapper to be created but will *not* actually clone/checkout
# the repository (will not invoke the git resource).  This is useful
# when using deploy resources as the credentials can be dropped in
# place using 'git_private_repo' and the resulting SSH wrapper script
# passed to the deploy resource using the 'git_ssh_wrapper_path_for'
# helper function.
#
# For repositories which require multiple private keys (perhaps
# because of multiple, different credentials required for submodules)
# another usage is available:
#
#   git_private_repo 'foobar' do
#     repository 'git@github.com:myaccount/foobar.git'
#     path       '/var/www/foobar'
#
#     # Assumes cookbook files named "repo1.pem" and "repo2.pem" exist
#     # in this cookbook
#     private_keys_files ['repo1', 'repo2']
#
#     # Allows for passing the contents of a key directly, useful if
#     # it is assigned dynamically or you don't want to include it in
#     # a cookbook.
#     private_keys_contents({
#       'repo3' => '...contents of private key for repo 3...',
#       'repo4' => '...contents of private key for repo 4...'
#     })
#
#     # For git repos/submodules without a user defined,
#     # the ssh wrapper sets a default user of 'git',
#     # which can be changed here.
#     default_ssh_user 'git'
#   end
#
# All the keys, both those sourced from cookbook files
# ('private_keys_files') and those passed explicitly
# ('private_keys_contents') will be dropped into '/etc/deploy/foobar'.
# Only one SSH wrapper will be created but it will name all these
# keys.
#     
define :git_private_repo, :action => :checkout, :repository => nil, :path => nil, :user => nil, :group => nil, :branch => 'master', :enable_submodules => true, :private_keys_contents => {}, :private_keys_files => [], :default_ssh_user => 'git' do

  #
  # Make sure the deploy key directory exists.
  #
  standard_dirs "git" do
    directories :deploy_root
  end
  deploy_dir = File.join(node[:git][:deploy_root], params[:name])
  directory deploy_dir do
    mode    '0755'
    action  :create
  end
  

  #
  # Private keys
  #

  if params[:private_keys_contents].empty? && params[:private_keys_files].empty?
    # With no explicit key contents or cookbook file names given, we
    # assume there exists a cookbook file named after params[:name]
    cookbook_file File.join(deploy_dir, "#{params[:name]}.pem") do
      source  "#{params[:name]}.pem"
      mode    '0600'
      action  :create
    end
  else
    # Otherwise we explicitly create private keys based on the keys
    # contents and the keys files.
    params[:private_keys_contents].each_pair do |name, data|
      file File.join(deploy_dir, "#{name}.pem") do
        content  data
        mode     '0600'
        action   :create
      end
    end
    params[:private_keys_files].each do |name|
      cookbook_file File.join(deploy_dir, "#{name}.pem") do
        source  "#{name}.pem"
        mode    '0600'
        action  :create
      end
    end
  end

  #
  # Create the SSH wrapper
  #
  ssh_wrapper_path = File.join(deploy_dir, "#{params[:name]}.sh")
  if params[:private_keys_contents].empty? && params[:private_keys_files].empty?
    private_key_path          = File.join(deploy_dir, "#{params[:name]}.pem")
    private_keys_paths_string = "-i #{private_key_path}"
  else
    private_keys_paths = (params[:private_keys_contents].keys + params[:private_keys_files]).map do |name|
      File.join(deploy_dir, "#{name}.pem")
    end
    private_keys_paths_string = private_keys_paths.map { |path| "-i #{path}" }.join(' ')
  end
  
  template ssh_wrapper_path do
    variables :private_keys_paths_string => private_keys_paths_string, :default_ssh_user => params[:default_ssh_user]
    source    'ssh_wrapper.sh.erb'
    cookbook  'git'
    mode      '0744'
    action    :create
  end

  #
  # Now clone the repo -- but not if we're not supposed to, useful for
  # deploy_revision resource where we must initialize the wrapper but
  # not clone the repo.
  #

  unless params[:action] == :ssh_wrapper
    directory File.dirname(params[:path]) do
      if params[:group]
        group   params[:group]
        mode    '0775'
      else
        mode    '0755'
      end
      action    :create
      recursive true
    end
    
    git params[:path] do
      ssh_wrapper ssh_wrapper_path
      repository  params[:repository]
      branch      params[:branch]
      if params[:user]
        user params[:user]
      end
      if params[:group]
        group       params[:group]
      end
      action      params[:action]
      enable_submodules params[:enable_submodules]
    end
  end
  
end
