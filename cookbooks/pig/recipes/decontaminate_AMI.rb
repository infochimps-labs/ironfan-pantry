# FIXME :Remove the pig link on the AMI
link "/usr/local/bin/pig" do
  action :delete
  only_if { File.symlink?('/usr/local/bin/pig') }
end
