private_key_path = rundeck_ssh_private_key_path

bash "Generate SSH client keys" do
  code     "su rundeck -s/bin/bash -c\"ssh-keygen -N '' -f #{private_key_path}\""
  creates  private_key_path
end
