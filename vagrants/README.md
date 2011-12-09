You can use [VeeWee](https://raw.github.com/jedi4ever/veewee/),
[Vagrant](http://vagrantup.com) and
[Virtualbox](http://download.virtualbox.org/virtualbox/) to make chef
development ridiculously funner.

## Installing the Virtualbox image for the first time:

### Install Virtualbox

Download and install Virtualbox 4.x -- visit http://download.virtualbox.org/virtualbox/

### Install the gems

Run bundle install from your homebase directory

    $ cd cluster_chef_homebase
    $ bundle install

If this worked so far, you should be able to list all templates:

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
    $ vagrant basebox build 'oneiric-base'

If you don't have the iso file it will download it for you. The ISO file is huge, and will probably take about 30 minutes to pull in.

This will

* create a machine + disk according to the definition.rb
* Note: :os_type_id = The internal Name Virtualbox uses for that Distribution
* Mount the ISO File :iso_file
* Boot up the machine and wait for :boot_time
* Send the keystrokes in :boot_cmd_sequence
* Startup a webserver on :kickstart_port to wait for a request for the :kickstart_file (don't navigate to the file in your browser or the server will stop and the installer will not be able to find your preseed)
* Wait for ssh login to work with :ssh_user , :ssh_password
* Sudo execute the :postinstall_files

Next, export the vm to a .box file

    $ vagrant basebox export 'oneiric-base'

This will result in a oneiric-base.box -- it's simply calling `vagrant package --base 'oneiric-base' --output 'boxes/oneiric-base.box'`

### Add the box as one of your boxes

Import the box into vagrant:

    $ cd cluster_chef_homebase/vagrants
    $ vagrant box add 'oneiric-base' 'oneiric-base.box'

__________________________________________________________________________

## Launch a VM with vagrant

To use it:

    $ vagrant init 'oneiric-base'
    $ vagrant up
    $ vagrant ssh

* did the chef solo run by hand not vagrant
* swap out the /chef directory
* copy in the pems and the certificates directory


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
    
