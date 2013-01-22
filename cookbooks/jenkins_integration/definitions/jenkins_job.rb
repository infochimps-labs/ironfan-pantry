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
  :tasks        => [],          # Array of shell scripts templates to run
  :templates    => [],          # Array of templates to deploy
  ) do

  entities = HTMLEntities.new

  # Jenkins and bundle hate paths with spaces
  params[:name]         = params[:name].sub(' ','_')
  params[:downstream]   = params[:downstream].map {|r| r.sub(' ','_') }
  params[:path]         ||= "#{node[:jenkins][:lib_dir]}/jobs/#{params[:name]}"

  directory params[:path] do
    owner       node[:jenkins][:server][:user]
    group       node[:jenkins][:server][:group]
  end

  (params[:tasks] + params[:templates]).each do |file|
    template "#{params[:path]}/#{file}" do
      source    "#{file}.erb"
      mode      '0700'
      owner     node[:jenkins][:server][:user]
      group     node[:jenkins][:server][:group]
    end
  end

  template params[:path] + '/config.xml' do
    source      'config.xml.erb'
    variables   params
    owner       node[:jenkins][:server][:user]
    group       node[:jenkins][:server][:group]
    notifies    :restart, 'service[jenkins_server]', :delayed
  end

end
