action :add do
  ruby "Adding #{new_resource.username} to vsftp" do
    code <<-RUBY
    def run
      @file = '#{node[:vsftpd][:user_passwd_file]}'
      @user = '#{new_resource.username}'
      @pass = '#{new_resource.password}'
      return if already_there?
      remove_old
      update
      write
    end

    def already_there?
      @lines = File.readlines(@file).map {|l| l.chomp }
      @line = @lines.grep(Regexp.new('^' + @user + ':')).first
      return false unless @line
      # bepa:$apr1$HrD9LTfI$MLChClm38i9paWaAjtECI0
      pass = @line.split(':',2).last
      salt = pass.split('$')[2]
      return false unless salt
      with_this_salt = IO.popen('openssl passwd -1 -salt '+salt+' '+@pass) {|p| p.read}.chomp
      return with_this_salt == pass
    end

    def remove_old
      @lines -= [@line]
    end

    def update
      pass = IO.popen('openssl passwd -1 '+@pass) {|p| p.read}.chomp
      @lines << [@user,pass].join(':')
    end

    def write
      File.open(@file, "w") { |f| f.puts @lines.join("\n") }
    end

    run
    RUBY
    notifies :restart, resources(:service => "vsftpd"), :delayed
  end

  file "#{node[:vsftpd][:user_config_dir]}/#{new_resource.username}" do
    owner "root"
    group "root"
    mode 0644
    root = "local_root=#{new_resource.root.sub(%r!/\./.*!,'')}\n"
    user = "guest_username=#{new_resource.local_user}\n" unless new_resource.local_user.to_s.empty?
    content "#{root}#{user}"
    notifies :restart, resources(:service => "vsftpd"), :delayed
  end
end

action :remove do
  bash "Removing #{new_resource.username} from vsftpd authentication" do
    code %{
      sed -i '/#{new_resource.username}.*/ d' #{node[:vsftpd][:user_passwd_file]}
    }
    notifies :restart, resources(:service => "vsftpd"), :delayed
  end

  file "#{node[:vsftpd][:user_config_dir]}/#{new_resource.username}" do
    action :delete
    notifies :restart, resources(:service => "vsftpd"), :delayed
  end
end

def load_current_resource
  service "vsftpd" do
    supports :status => true, :stop => true, :start => true, :restart => true
  end

  file node[:vsftpd][:user_passwd_file] do
    owner "root"
    group "root"
    mode 0600
    action :create_if_missing
  end
end
