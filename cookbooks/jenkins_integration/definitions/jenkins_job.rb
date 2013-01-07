# Shorthand for deploying a descendent of ironfan-homebase, so that it
#   may be used to test Ironfan deployment

define(:jenkins_job,
  :repository   => nil,         # Source repository
  :branches     => 'master',    # Which branches to build
  :path         => nil,         # Path to clone to, overrides base_path
  :tasks        => []           # Array of shell scripts to run
  ) do

  params[:name].sub!(' ','_')   # Jenkins and bundle hate paths with spaces
  params[:path] ||= "#{node[:jenkins][:lib_dir]}/jobs/#{params[:name]}"

  directory params[:path] do
    owner       node[:jenkins][:server][:user]
    group       node[:jenkins][:server][:group]
  end

  template params[:path] + '/config.xml' do
    source      'config.xml.erb'
    variables   :repository => params[:repository],
                :branches   => params[:branches],
                :tasks => params[:tasks]
    owner       node[:jenkins][:server][:user]
    group       node[:jenkins][:server][:group]
    notifies    :restart, 'service[jenkins_server]', :delayed
  end

end
