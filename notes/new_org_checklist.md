** TODO: why aren't security groups being found

TODO: patch chef for no flat file in template (MAY be fixed in 10.after 4)
TODO: need a registry for snapshots. The blacklocus 1gb 1gb resizable is snap-34a82f50 and the homebase is snap-a2a82fc6
TODO: zabbix::default should NOT install services that start on boot.
TODO: volumes::mount should WARN LOUDLY (but not fail) when the drive is not available to mount
TODO: Make sure the nfs server doesn't clobber the ubunutu user

TODO (BL): remove directly-customized security group changes in AWS console

TODO (BL): snapshot the home dir and replace in the urza cluster

TODO (BL): fix chef environment to look for home dirs in the right cluster

> FIXED: patch chef for the resource thing ON the AMI (chef 10.4 swallows all template errors whcih SUCKS MY BALLS to debug)

TODO: let me specify the third arg to `announce` as a string for the realn (or if a hash as a hash)

TODO: ~~~ FIX NFS ANNOUNCING EVERYWHERE ELSE ~~~


TODO: fucking zabbix recipe sets a user with no explicit uid

== Zookeeper

* make a credentials repo
  - copy the knife/example-credentials directory
  - best to not live on github: use a private server and run
   
    ``` 
    repo=ORGANIZATION-credentials ; repodir=/gitrepos/$repo.git ; mkdir -p $repodir ; ( GIT_DIR=$repodir git init --shared=group --bare  && cd $repodir && git --bare update-server-info && chmod a+x hooks/post-update ) 
    ```
    
  - git submodule it into knife as `knife/yourorg-credentials`
  - or, if somebody has added it,
  
    ```
    git pull
    git submodule update --init
    find . -iname '*.pem' -exec chmod og-rw {} \;
    cp knife/${OLD_CHEF_ORGANIZATION}-credentials/knife-user-${CHEF_USER}.rb knife/${CHEF_ORGANIZATION}-credentials
    cp knife/${OLD_CHEF_ORGANIZATION}-credentials/${CHEF_USER}.pem knife/${CHEF_ORGANIZATION}-credentials/
    ```
    

* create AWS account
  - [sign up for AWS + credit card + password]
  - make IAM users for admins
  - add your IAM keys into your {credentials}/knife-user

* create opscode account
  - download org keys, put in the credentials repo
  - create `prod` and `dev` environments by using `knife environment create dev` + `knife environment create prod`. You don't need to do anything to them.  

```ruby
knife cookbook upload --all
rake roles
# if you have data bags, do that too
```

* start with the burninator cluster
* knife cluster launch --bootstrap --yes burninator-trogdor-0
  - if this fails, `knife cluster bootstrap --yes burninator-trogdor-0`

* ssh into the burninator and run the script /tmp/burn_ami_prep.sh

* review ps output and ensure happiness with what is running. System should be using ~3G on the main drive

* once that works,
  - go to AWS console
  - stop the machine
  - do "Burn AMI"

* add the AMI id to your `{credentials}/knife-org.rb` in the `ec2_image_info.merge!` section


NFS home
* copy the control cluster def'n
* make yourself a 20GB drive, format it XFS, snapshot it, delete the original. Paste the snapshot ID into the cluster defn (not eternally necessary but ...)

```
  # first create a volume in the console and mount it at /dev/xvdh
  dev=/dev/xvdh ; name='home_drive'      ; sudo umount $dev ; ls -l $dev ; sudo mkfs.xfs $dev ; sudo mkdir /mnt/$name ; sudo mount -t xfs $dev /mnt/$name ; sudo bash -c "echo 'snapshot for $name burned on `date`' > /mnt/$name/vol_info.txt "
  sudo cp -rp /home/ubuntu /mnt/$name/ubuntu
  sudo bash -c "echo '' >  /mnt/$name/ubuntu/.ssh/authorized_keys"
  sudo umount /dev/xvdh
  # now in the console snapshot that shizz
```

Name it {org}-home_drive
While you're in there, make {org}-resizable_1gb a 'Minimum-sized snapshot, resizable -- use xfs_growfs to resize after launch' snapshot.

!! TODO!

restart the nfs-server node through the AWS console

Hope you followed the directions for snapshot prep, or if you didn't that you didn't clobber the ubuntu user when the home dir is mounted....

__________________________________________________________________________
(not eternally necessary but ...)



TODO: flume cookbook has discovery and announce out of order
