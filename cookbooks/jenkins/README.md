# jenkins chef cookbook

Installs and configures Jenkins CI server & workers

## Overview

= DESCRIPTION:

Installs and configures Jenkins CI server & node workers.  Resource providers to support automation via jenkins-cli, including job create/update.

### Notes

#### Compatibility:
 
* 'default' - Server installation - currently supports Red Hat/CentOS 5.x and Ubuntu 8.x/9.x/10.x
* 'node_ssh' - Any platform that is running sshd.
* 'node_jnlp' - Unix platforms. (depends on runit recipe)
* 'node_windows' - Windows platforms only.  Depends on .NET Framework, which can be installed with the windows::dotnetfx recipe.

#### Jenkins node authentication:

If your Jenkins instance requires authentication, you'll either need to embed user:pass in the jenkins.server.url or issue a jenkins-cli.jar login command prior to using the jenkins::worker_* recipes.  For example, define a role like so:

  name "jenkins_ssh_node"
  description "cli login & register ssh worker with Jenkins"
  run_list %w(vmw::jenkins_login jenkins::worker_ssh)

Where the jenkins_login recipe is simply:

  jenkins_cli "login --username #{node[:jenkins][:username]} --password #{node[:jenkins][:password]}"


#### ISSUES

* CLI authentication - http://issues.jenkins-ci.org/browse/JENKINS-3796

* CLI *-node commands fail with "No argument is allowed: nameofworker" - http://issues.jenkins-ci.org/browse/JENKINS-5973

#### LICENSE & AUTHOR:

This is a downstream fork of Doug MacEachern's Hudson cookbook (https://github.com/dougm/site-cookbooks) and therefore deserves all the glory.

Author:: Doug MacEachern (<dougm@vmware.com>)

Contributor:: Fletcher Nichol <fnichol@nichol.ca>
Contributor:: Roman Kamyk <rkj@go2.pl>
Contributor:: Darko Fabijan <darko@renderedtext.com>

## Attributes

* `[:apt][:jenkins][:url]`            - URL of apt repo for downloading Jenkins (server) (default: "http://pkg.jenkins-ci.org/debian")
* `[:jenkins][:plugins_mirror]`       -  (default: "http://updates.jenkins-ci.org")
* `[:java][:java_home]`            - Java install path, used for for cli commands (default: "/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home")
* `[:jenkins][:iptables_allow]`       - if iptables is enabled, add a rule passing 'jenkins[:server][:port]' (default: "enable")
* `[:jenkins][:server][:home_dir]`        - JENKINS_HOME directory (default: "/var/lib/jenkins")
* `[:jenkins][:server][:user]`        - User the Jenkins server runs as (default: "jenkins")
* `[:jenkins][:server][:group]`       -  (default: "nogroup")
  - Jenkins user primary group
* `[:jenkins][:server][:port]`        - TCP listen port for the Jenkins server (default: "8080")
* `[:jenkins][:server][:host]`        - Host interface address for the Jenkins server
* `[:jenkins][:server][:java_heap_size_max]`    - tunable: Java maximum heap size (default: "384")
* `[:jenkins][:server][:plugins]`     - Download the latest version of plugins in this list, bypassing update center
* `[:jenkins][:server][:use_head]`    - working around: http://tickets.opscode.com/browse/CHEF-1848; set to true if you have the CHEF-1848 patch applied
* `[:jenkins][:worker][:name]`          - Name of the node within Jenkins
* `[:jenkins][:worker][:description]`   - Jenkins node description (default: "ubuntu 10.4 [  ] worker on hostname")
* `[:jenkins][:worker][:executors]`     - Number of node executors (default: "1")
* `[:jenkins][:worker][:home_dir]`          - Home directory (`Remote FS root`) of the node (default: "/var/lib/jenkins-node")
* `[:jenkins][:worker][:labels]`        - Node labels
* `[:jenkins][:worker][:mode]`          - Node usage mode, `normal` or `exclusive` (tied jobs only) (default: "normal")
* `[:jenkins][:worker][:launcher]`      - Node launch method: `jnlp`, `ssh` or `command` (default: "ssh")
* `[:jenkins][:worker][:availability]`  - `always` keeps node on-line, `demand` off-lines when idle (default: "always")
* `[:jenkins][:worker][:in_demand_delay]` - number of minutes for which jobs must be waiting in the queue before attempting to launch this worker. (default: "0")
* `[:jenkins][:worker][:idle_delay]`    - number of minutes that this worker must remain idle before taking it off-line.  (default: "1")
* `[:jenkins][:worker][:env]`           - `Node Properties` -> `Environment Variables`
* `[:jenkins][:worker][:user]`          - user the worker runs as (default: "jenkins-node")
* `[:jenkins][:worker][:ssh_host]`      - Hostname or IP Jenkins should connect to when launching an SSH worker
* `[:jenkins][:worker][:ssh_port]`      - SSH worker port (default: "22")
* `[:jenkins][:worker][:ssh_user]`      - SSH worker user name (only required if jenkins server and worker user is different) (default: "22")
* `[:jenkins][:worker][:ssh_pass]`      - SSH worker password (not required when server is installed via default recipe)
* `[:jenkins][:worker][:jvm_options]`   - SSH worker JVM options
* `[:jenkins][:worker][:ssh_private_key]` - jenkins master defaults to: `~/.ssh/id_rsa` (created by the default recipe)
* `[:jenkins][:http_proxy][:variant]` - use `nginx` or `apache2` to proxy traffic to jenkins backend (`nil` by default)
* `[:jenkins][:http_proxy][:www_redirect]` - add a redirect rule for 'www.*' URL requests ("disable" by default) (default: "disable")
* `[:jenkins][:http_proxy][:listen_ports]` - list of HTTP ports for the HTTP proxy to listen on ([80] by default)
* `[:jenkins][:http_proxy][:host_name]` - primary vhost name for the HTTP proxy to respond to (`node[:fqdn]` by default)
* `[:jenkins][:http_proxy][:host_aliases]` - optional list of other host aliases to respond to (empty by default)
* `[:jenkins][:http_proxy][:client_max_body_size]` - max client upload size (`1024m` by default, nginx only) (default: "1024m")

## Recipes 

* `auth_github_oauth`        - Auth Github Oauth
* `build_from_github`        - Build From Github
* `build_ruby_rspec`         - Build Ruby Rspec
* `default`                  - Installs a Jenkins CI server using the http://jenkins-ci.org/redhat RPM.  The recipe also generates an ssh private key and stores the ssh public key in the node 'jenkins[:server][:public_key]' attribute for use by the node recipes.
* `iptables`                 - Set up ip_tables to allow access to the daemons
* `node_jnlp`                - Creates the user and group for the Jenkins worker to run as and '/jnlpJars/worker.jar' is downloaded from the Jenkins server.  Depends on runit_service from the runit cookbook.
* `node_ssh`                 - Creates the user and group for the Jenkins worker to run as and sets `.ssh/authorized_keys` to the 'jenkins[:server][:public_key]' attribute.  The 'jenkins-cli.jar'[1] is downloaded from the Jenkins server and used to manage the nodes via the 'groovy'[2] cli command.  Jenkins is configured to launch a worker agent on the node using its SSH worker plugin[3].

[1] http://wiki.jenkins-ci.org/display/JENKINS/Jenkins+CLI
[2] http://wiki.jenkins-ci.org/display/JENKINS/Jenkins+Script+Console
[3] http://wiki.jenkins-ci.org/display/JENKINS/SSH+Workers+plugin
* `node_windows`             - Creates the home directory for the node worker and sets 'JENKINS_HOME' and 'JENKINS_URL' system environment variables.  The 'winsw'[1] Windows service wrapper will be downloaded and installed, along with generating `jenkins-worker.xml` from a template.  Jenkins is configured with the node as a 'jnlp'[2] worker and '/jnlpJars/worker.jar' is downloaded from the Jenkins server.  The 'jenkinsworker' service will be started the first time the recipe is run or if the service is not running.  The 'jenkinsworker' service will be restarted if '/jnlpJars/worker.jar' has changed.  The end results is functionally the same had you chosen the option to 'Let Jenkins control this worker as a Windows service'[3].

[1] http://weblogs.java.net/blog/2008/09/29/winsw-windows-service-wrapper-less-restrictive-license
[2] http://wiki.jenkins-ci.org/display/JENKINS/Distributed+builds
[3] http://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+as+a+Windows+service
* `proxy_apache2`            - Uses the apache2 recipe from the apache2 cookbook to install an HTTP frontend proxy. To automatically activate this recipe set the `node[:jenkins][:http_proxy][:variant]` to `apache2`.
* `proxy_nginx`              - Uses the nginx::source recipe from the nginx cookbook to install an HTTP frontend proxy. To automatically activate this recipe set the `node[:jenkins][:http_proxy][:variant]` to `nginx`.
* `server`                   - Server
* `user_key`                 - User Key
## Integration

Supports platforms: debian and ubuntu

Cookbook dependencies:
* java
* apache2
* nginx
* runit
* iptables
* mountable_volumes
* provides_service


## License and Author

Author::                Fletcher Nichol (<fnichol@nichol.ca>)
Copyright::             2011, Fletcher Nichol

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

> readme generated by [ironfan](http://github.com/infochimps-labs/ironfan)'s cookbook_munger
