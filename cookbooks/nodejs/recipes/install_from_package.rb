
if platform?('centos')
  execute "yum clean all" do
    action :nothing
  end

  remote_file "/etc/yum.repos.d/nodejs-stable.repo" do
    source "http://nodejs.tchol.org/repocfg/el/nodejs-stable.repo"
    mode "0644"
    notifies :run, resources(:execute => "yum clean all"), :immediately
  end
end

package "nodejs"
package "npm"

link node[:nodejs][:bin_path] { to '/usr/bin/nodejs' } if platform?('centos')
