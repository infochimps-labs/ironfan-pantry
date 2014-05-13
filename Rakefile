
desc "Run all cookbook specs in their own environment (cookbook_name is optional)"
task :spec,[:cookbook_name] do |t,args|
  cookbooks_to_run = args[:cookbook_name] ? [File.join("cookbooks",args[:cookbook_name],"spec")] : Dir["cookbooks/*/spec/"]
  cookbooks_to_run.reject!{|cbk| cbk =~ /silverware/}
  spec_helper_path = File.expand_path("spec/spec_helper.rb")
  gemfile_path     = File.expand_path("Gemfile")
  exit_statuses = cookbooks_to_run.map do |cbk_path|
    cbk_path   = File.join(cbk_path,"..")
    sh_command = "cd #{cbk_path}; BUNDLE_GEMFILE=#{gemfile_path} bundle exec rspec -r #{spec_helper_path} --format documentation"
    sh(sh_command){ |ok,status| ok}
  end
  exit exit_statuses.all?
end

task :default => :spec
