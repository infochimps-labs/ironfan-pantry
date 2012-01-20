
### Install cluster_chef-homebase

Clone this repo, producing the directory we'll call `homebase` from now on. In fact, you may wish to rename it:

        git clone https://github.com/infochimps-labs/cluster_chef-homebase
        mv cluster_chef-homebase homebase
        cd homebase
        git submodule update --init

Now follow the instructions

* from [the main directory README.md](README.md), for overall setup
* from [the knife/ folder README.md](knife/README.md), for chef config file setup
    
you're ready to go when you can `knife cluster list` and get formatted output:

        $ knife cluster list
        +--------------------+---------------------------------------------------+
        | cluster            | path                                              |
        +--------------------+---------------------------------------------------+
        | burninator         | /cloud/clusters/burninator.rb                     |
        | hadoop_demo        | /cloud/clusters/hadoop_demo.rb                    |
          ...                  ...
        | sandbox            | /cloud/clusters/sandbox.rb                        |
        +--------------------+---------------------------------------------------+


## Installing the Vagrant box for the first time:

### Install Virtualbox

Download and install Virtualbox 4.x -- visit http://download.virtualbox.org/virtualbox/

### Install the gems

Run bundle install from your homebase directory

        $ cd cluster_chef_homebase
        $ bundle install

You should now be able to list all templates:

        $ vagrant basebox templates
        The following templates are available:
        # ....
        vagrant basebox define '<boxname>' 'ubuntu-10.10-server-amd64'-netboot'
        # ...
        vagrant basebox define '<boxname>' 'ubuntu-11.10-server-amd64-ruby192'

### Build the new box

(_If you alread have the box in the vagrants/boxes folder, skip to 'Add the box'._)

Now move into the vagrants/ subdirectory and run

        $ cd cluster_chef_homebase/vagrants
        $ vagrant basebox build 'cluster-chef-natty'

If you don't have the iso file it will download it for you. The ISO file is huge, and will probably take about 30 minutes to pull in.

The `basebox build` command will

* create a machine + disk according to the definition.rb
* Note: :os_type_id = The internal Name Virtualbox uses for that Distribution
* Mount the ISO File :iso_file
* Boot up the machine and wait for `:boot_time`
* Send the keystrokes in `:boot_cmd`_sequence
* Startup a webserver on `:kickstart_port` to wait for a request for the `:kickstart_file` (don't navigate to the file in your browser or the server will stop and the installer will not be able to find your preseed)
* Wait for ssh login to work with :ssh_user , :ssh_password
* Sudo execute the :postinstall_files

Next, export the vm to a .box file (producing `cluster-chef-natty.box`)

        $ vagrant basebox export cluster-chef-natty
        $ mv cluster-chef-natty.box boxes/cluster-chef-natty.box

### Add the box as one of your boxes

Import the box into vagrant:

        $ vagrant box add 'cluster-chef-natty' 'boxes/cluster-chef-natty.box'

__________________________________________________________________________

## Launch a VM with vagrant

To use it:

        $ cd vagrants/cocina-chef_server
        $ vagrant up
        $ vagrant ssh
    
FIXME: this will break; it's trying to look in cloud/cookbooks/cookbooks
  for cookbooks. ssh in, edit the /etc/chef/solo.rb file, and run chef-client by hand

__________________________________________________________________________

## Once your chef server is up

* visit the webui (at http://33.33.33.20:4040 by default).

* log in with username 'admin' and password p@ssw0rd1 -- it will immediately prompt you to change it.

* [Create an admin=true client](http://33.33.33.20:4040/clients/new) for
  yourself. If you have an opscode platform user account, make life easy on
  yourself and use the same name. Check the box 'yes' for admin
  
* Copy-paste the private key into `{homebase}/knife/cocina/{yourname}.pem`
  - Do so immediately -- it's your only chance to get the key!
  - The first and last lines of the file should be the `-----BEGIN...` and
  `-----END..` blocks.
  - do a `chmod 600 {homebase}/knife/cocina/{yourname}.pem`
  
* [Create the 'vm_dev' environment](http://33.33.33.20:4040/environments/new)
  - you don't need to set anything, just create it.

* go to cluster_chef_homebase/knife and make a copy of the credentials directory for the cocina world

        cd cluster_chef_homebase/knife 
        cp -rp example cocina
        cd cocina
        git init ; git add .
        git commit -m "New credentials univers for local VM chef server" .
    
  subdirectories of `cluster_chef_homebase/knife` are .gitignored; don't check this directory into git.

* upload your cookbooks!

        cd /cloud
        bundle install
        export CHEF_USER=yourchefusername CHEF_ORGANIZATION=cocina CHEF_HOMEBASE=/cloud
        rake roles &    # NEVA GONNA GIVE YOU UP...
        knife cookbook upload --all

### Make the chef_server a client of itself

* edit the file `cocina/cloud.rb`, and set

        chef_server_url "http://33.33.33.20:4000/"

* ssh to the chef_server vm, 

        vagrant ssh
    
  copy the server's copy of the validator so the machine can also be a client, 
  and grab a copy for posterity

        cd /etc/chef
        sudo ln -s validation.pem  cocina-validator.pem 
        sudo cp    validation.pem  /cloud/knife/cocina/cocina-validator.pem
        sudo mv    dna.json        /cloud/knife/cocina/dna/cocina-chef_server-0.json
        sudo ln -s /cloud/knife/cocina/dna/cocina-chef_server-0.json dna.json
        sudo ln -s /cloud/knife/cocina/client_keys                   client_keys

        # when those finish,
        sudo chef-client
