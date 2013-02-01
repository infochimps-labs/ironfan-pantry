# Shorthand for deploying a Jenkins job
# FIXME: This is in some ways well in advance of the native jenkins job provider.
#   In other ways, it's well behind. Merge them, at some point.
# FIXME: use https://wiki.jenkins-ci.org/display/JENKINS/Job+DSL+Plugin
#   instead of developing this DSL->XML transformation further
define(:jenkins_job,
  :branch       => 'master',    # Which branch to build
  :downstream   => [],          # What downstream jobs to kick off on a good run
  :final        => [],          # What final jobs to kick off when downstreams are done
  :final_params => [],          # What parameters to pass to final jobs
  :merge        => nil,         # What branch to attempt to merge and push
  :path         => nil,         # Path to clone to, overrides base_path
  :project      => nil,         # Source project URL
  :parameters   => {},          # If the job is parameterized, list those params
  :repository   => nil,         # Source repository
  :triggers     => {},          # Triggers to start this job
  :tasks        => [],          # Array of shell scripts templates to run
  :templates    => [],          # Array of templates to deploy
  ) do

  # Jenkins and bundle hate paths with spaces
  params[:name]         = params[:name].sub(' ','_')
  params[:downstream]   = params[:downstream].map {|r| r.sub(' ','_') }
  params[:path]         ||= "#{node[:jenkins][:lib_dir]}/jobs/#{params[:name]}"

  directory params[:path] do
    owner       node[:jenkins][:server][:user]
    group       node[:jenkins][:server][:group]
  end

  # The tasks each dump a script, and they are executed in order,
  #   the overall job failing if any of them return non-zero status.
  (params[:tasks] + params[:templates]).each do |file|
    template "#{params[:path]}/#{file}" do
      source    "#{file}.erb"
      variables params
      mode      '0700'
      owner     node[:jenkins][:server][:user]
      group     node[:jenkins][:server][:group]
    end
  end

  template params[:path] + '/config.xml' do
    source      'job.config.xml.erb'
    variables   params
    owner       node[:jenkins][:server][:user]
    group       node[:jenkins][:server][:group]
    notifies    :restart, 'service[jenkins_server]', :delayed
  end

end
