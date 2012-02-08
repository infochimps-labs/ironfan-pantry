You can use [VeeWee](https://raw.github.com/jedi4ever/veewee/),
[Vagrant](http://vagrantup.com) and
[Virtualbox](http://download.virtualbox.org/virtualbox/) to make chef
development ridiculously funner.


These are the parts of the vagrant automation:

* convert cluster definition to Vagrantfile
* knife provisions vagrant servers
* a set of conventions for using Vagrant with chef in a local debugging or testing environment.


on desktop:
* ssh key for machine

on desktop and chef server:
* server.rb
* validation.pem
* validator.pem
* cookbooks
* roles

on desktop and chef client:
* chef-dna.json
* client.pem
* validator.pem
* client.rb
* data bag keys
