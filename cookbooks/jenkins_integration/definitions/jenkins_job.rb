# Shorthand for deploying a descendent of ironfan-homebase, so that it
#   may be used to test Ironfan deployment

require 'htmlentities'

define(:jenkins_job,
  :project      => nil,         # Source project URL
  :repository   => nil,         # Source repository
  :branches     => 'master',    # Which branches to build
  :path         => nil,         # Path to clone to, overrides base_path
  :triggers     => {},          # Triggers to start this job
  :tasks        => []           # Array of shell scripts to run
  ) do

  entities = HTMLEntities.new

  params[:name].sub!(' ','_')   # Jenkins and bundle hate paths with spaces
  params[:path] ||= "#{node[:jenkins][:lib_dir]}/jobs/#{params[:name]}"
  params[:tasks] = params[:tasks].map {|t| entities.encode t }

  directory params[:path] do
    owner       node[:jenkins][:server][:user]
    group       node[:jenkins][:server][:group]
  end

  template params[:path] + '/config.xml' do
    source      'config.xml.erb'
    variables   params
    owner       node[:jenkins][:server][:user]
    group       node[:jenkins][:server][:group]
    notifies    :restart, 'service[jenkins_server]', :delayed
  end

end
