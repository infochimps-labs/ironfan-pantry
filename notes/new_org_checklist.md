TODO: patch chef for no flat file in template (MAY be fixed in 10.after 4)
TODO: thrift version is dangerously behind

> FIXED: patch chef for the resource thing ON the AMI (chef 10.4 swallows all template errors whcih SUCKS MY BALLS to debug)

== Zookeeper

* make a credentials repo
  - copy the knife/example-credentials directory
  - best to not live on github
  - git submodule it into knife as `knife/yourorg-credentials`

* create AWS account
  - [sign up for AWS + credit card + password]
  - make IAM users for admins
  - add your IAM keys into your {credentials}/knife-user

* create opscode account
  - download org keys, put in the credentials repo
  

```ruby
knife cookbook upload --all
rake roles
# if you have data bags, do that too
```

* start with the burninator cluster
* knife cluster launch --bootstrap --yes burninator-trogdor-0
  - if this fails, `knife cluster bootstrap --yes burninator-trogdor-0`

* ssh into the burnitnrttrt and run the script /tmp/burn_ami_prep.sh

* review ps output and ensure happiness with what is running. System should be using ~3G on the main drive

* once that works,
  - go to AWS console
  - stop the machine
  - do "Burn AMI"

* add the AMI id to your `{credentials}/knife-org.rb` in the `ec2_image_info.merge!` section