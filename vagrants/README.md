You can use [VeeWee](https://raw.github.com/jedi4ever/veewee/),
[Vagrant](http://vagrantup.com) and
[Virtualbox](http://download.virtualbox.org/virtualbox/) to make chef
development ridiculously funner.

### Install cluster_chef_homebase

Clone our chef homebase:

    $ git clone http://github.com/infochimps-labs/cluster_chef_homebase.git
    
Below, when we refer to `cluster_chef_homebase` the directory just created.

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
    $ vagrant basebox build 'natty-base'

If you don't have the iso file it will download it for you. The ISO file is huge, and will probably take about 30 minutes to pull in.

The `basebox build` command will

* create a machine + disk according to the definition.rb
* Note: :os_type_id = The internal Name Virtualbox uses for that Distribution
* Mount the ISO File :iso_file
* Boot up the machine and wait for :boot_time
* Send the keystrokes in :boot_cmd_sequence
* Startup a webserver on :kickstart_port to wait for a request for the :kickstart_file (don't navigate to the file in your browser or the server will stop and the installer will not be able to find your preseed)
* Wait for ssh login to work with :ssh_user , :ssh_password
* Sudo execute the :postinstall_files

Next, export the vm to a .box file (producing `natty-base.box`)

    $ vagrant basebox export natty-base
    $ mv natty-base.box boxes/natty-base.box

### Add the box as one of your boxes

Import the box into vagrant:

    $ vagrant box add 'natty-base' 'boxes/natty-base.box'

__________________________________________________________________________

## Launch a VM with vagrant

To use it:

    $ cd vagrants/cocina-chef_server
    $ vagrant up
    $ vagrant ssh

__________________________________________________________________________

## Once your chef server is up

* visit the webui (at http://33.33.33.20:4040 by default).

* log in with username 'admin' and password p@ssw0rd1 -- it will immediately prompt you to change it.

* [Create an admin=true client](http://33.33.33.20:4040/clients/new) for
  yourself. If you have an opscode platform user account, make life easy on
  yourself and use the same name.
  
* Copy the private key into `{homebase}/knife/cocina/{yourname}.pem`, and chmod
  it 600. The first and last lines of the file should be the `-----BEGIN...` and
  `-----END..` blocks.
  
* [Create the 'vm_dev' environment](http://33.33.33.20:4040/environments/new)


* go to cluster_chef_homebase/knife and make a copy of the credentials directory for the cocina world


    cd cluster_chef_homebase/knife 
    cp -rp example cocina
    cd cocina
    git init ; git add .
    git commit -m "New credentials univers for local VM chef server"

* ssh to the chef_server vm, 

    $ vagrant ssh
    
  rename the validator into place, and grab a copy for yourself
  
    sudo cp    validation.pem  /cloud/knife/cocina/cocina-validator.pem
    sudo ln -s validation.pem  cocina-validator.pem 
    sudo ln -s /cloud/knife/cocina/dna /etc/chef/dna

    cd /cloud
    bundle install
    rake roles &    # NEVA GONNA GIVE YOU UP...
    knife cookbook upload --all
    # when those finish
    sudo chef-client
    
