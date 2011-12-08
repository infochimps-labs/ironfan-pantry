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
