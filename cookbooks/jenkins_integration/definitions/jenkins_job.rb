# Shorthand for deploying a descendent of ironfan-homebase, so that it
#   may be used to test Ironfan deployment

require 'htmlentities'

define(:jenkins_job,
  :branches     => 'master',    # Which branches to build
  :downstream   => [],          # What downstream jobs to kick off on a good run
  :path         => nil,         # Path to clone to, overrides base_path
  :project      => nil,         # Source project URL
  :repository   => nil,         # Source repository
  :triggers     => {},          # Triggers to start this job
  :tasks        => []           # Array of shell scripts to run
  ) do

  entities = HTMLEntities.new

  # Jenkins and bundle hate paths with spaces
  params[:name]         = params[:name].sub(' ','_')
  params[:downstream]   = params[:downstream].map {|r| r.sub(' ','_') }
  # Tasks need to be HTML-encoded
  params[:tasks]        = params[:tasks].map {|t| entities.encode t }
  params[:path]         ||= "#{node[:jenkins][:lib_dir]}/jobs/#{params[:name]}"

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
