# Shorthand for deploying a Jenkins job
# FIXME: This is in some ways well in advance of the native jenkins job provider.
#   In other ways, it's well behind. Merge them, at some point.
# FIXME: use https://wiki.jenkins-ci.org/display/JENKINS/Job+DSL+Plugin
#   instead of developing this DSL->XML transformation further
define(:jenkins_job,
  :branch       => 'master',    # Which branch to build
  :conditional  => {},          # Array of parameters for a conditional downstream build
  :downstream   => [],          # What downstream jobs to kick off on a good run
  :final        => [],          # What final jobs to kick off when downstreams are done
  :final_params => {},          # What parameters to pass to final jobs
  :homebases    => [],          # Ironfan homebases to clone for testing
  :merge        => nil,         # What branch to attempt to merge and push
  :path         => nil,         # Path to clone to, overrides base_path
  :project      => nil,         # Source project URL
  :parameters   => {},          # If the job is parameterized, list those params
  :pantries     => [],          # Ironfan pantries to clone for testing
  :repositories => [],          # Source repositories
  :retention    => {},          # How long to keep build logs
  :triggers     => {},          # Triggers to start this job
  :tasks        => [],          # Array of shell scripts templates to run
  :templates    => [],          # Array of templates to deploy
  ) do

  # Jenkins and bundle hate paths with spaces
  params[:name]         = params[:name].gsub(' ','_')
  params[:downstream]   = params[:downstream].map {|r| r.gsub(' ','_') }
  params[:final]        = params[:final].map {|r| r.gsub(' ','_') }
  params[:path]         ||= "#{node[:jenkins][:lib_dir]}/jobs/#{params[:name]}"
  if params[:conditional][:target]
    params[:conditional][:target] = params[:conditional][:target].gsub(' ','_')
  end

  directory params[:path] do
    owner       node[:jenkins][:server][:user]
    group       node[:jenkins][:server][:group]
  end

  # The tasks each dump a script, and they are executed in order,
  #   the overall job failing if any of them return non-zero status.
  (params[:tasks] + params[:templates]).each do |file_or_hash|

    if file_or_hash.is_a?(Hash)
      tname = file_or_hash[:name]
      tcookbook = file_or_hash[:cookbook]
    else
      tname = file_or_hash
      tcookbook = 'jenkins_integration'
    end

    template "#{params[:path]}/#{tname}" do
      source    "#{tname}.erb"
      cookbook  tcookbook
      variables params
      mode      '0700'
      owner     node[:jenkins][:server][:user]
      group     node[:jenkins][:server][:group]
    end
  end

  template params[:path] + '/config.xml' do
    source      'job.config.xml.erb'
    cookbook    'jenkins_integration'
    variables   params
    owner       node[:jenkins][:server][:user]
    group       node[:jenkins][:server][:group]
    notifies    :restart, 'service[jenkins_server]', :delayed
  end

end
