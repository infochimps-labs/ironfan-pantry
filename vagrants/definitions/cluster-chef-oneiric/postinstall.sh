
# This is the ubuntu oneiric VM postinstall.sh script from infochimps'
# cluster_chef. It is based on Mitchell's official lucid32/64 baseboxes
# postinstall.sh script, with the following important differences:
#
# * installs ruby 1.9.2 (not 1.8.7) using the system ruby
# * upgrades rubygems rather than installing from source
# * pushes the node identity into the first-boot.json
# * installs the chef-client service and kicks off the first run of chef

set -e

RUBY_VERSION=1.9.1
CHEF_VERSION=0.10.08

mkdir -p /tmp/knife-bootstrap
chmod 700 /tmp/knife-bootstrap 
cd /tmp/knife-bootstrap

eval `cat /etc/lsb-release `
export DEBIAN_FRONTEND=noninteractive

date > /etc/vagrant_box_build_time
date > /etc/box_build_time

# source for sun java if you want to install it later
apt-get install -y python-software-properties
add-apt-repository -y ppa:ferramroberto/java

echo -e "`date` \n\n**** \n**** apt update:\n****\n"
apt-get -y update
apt-get -y upgrade

echo -e "`date` \n\n**** \n**** Installing base packages:\n****\n"
apt-get -y install linux-headers-$(uname -r)
apt-get -y install build-essential make wget curl runit zlib1g-dev libssl-dev openssl libcurl4-openssl-dev libxml2-dev libxslt-dev libyaml-dev libreadline6 libreadline6-dev
apt-get -y install libmysql++-dev libsqlite3-dev 
apt-get clean

# Setup sudo to allow no-password sudo for "admin"
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

# Install NFS client
apt-get -y install nfs-common

if [ ! -f /usr/bin/chef-client ]; then
echo -e "`date` \n\n**** \n**** Installing ruby version ${RUBY_VERSION}:\n****\n"

apt-get install -y ruby1.9.1 ruby1.9.1-dev

if ruby -e "exit(%x{gem --version} < \"1.6.2\" ? 0 : -1 )" ; then
  echo -e "`date` \n\n**** \n**** Updating rubygems:\n****\n"
  # screw you Debian
  REALLY_GEM_UPDATE_SYSTEM=1 gem update --system
  # screw you rubygems
  for foo in /usr/lib/ruby/site_ruby/*/rubygems/deprecate.rb ; do
    # Don't have to be any such deprecations, in which case $foo won't exist
    [ -f "$foo" ] && sudo sed -i.bak 's!@skip ||= false!true!' "$foo"
  done
fi

echo -e "`date` \n\n**** \n**** Installing chef:\n****\n"
gem install ohai --no-rdoc --no-ri
gem install chef --no-rdoc --no-ri --version=$CHEF_VERSION
# gems needed for the client.rb or so generically useful you want them at hand
gem install      --no-rdoc --no-ri extlib bundler json right_aws pry

else # no chef-client
echo -e "`date` \n\n**** \n**** Chef is present -- skipping apt/ruby/chef installation\n****\n"
fi # end ruby+chef install

# fix a bug in chef that prevents debugging template errors
# will not work with --prerelease but that's OK hopefully opscode patches this crap soon
bad_template_file="/usr/lib/ruby/gems/${RUBY_VERSION}/gems/chef-${CHEF_VERSION}/lib/chef/mixin/template.rb"
if  echo "0505c482b8b0b333ac71bbc8a1795d19  $bad_template_file" | md5sum -c - 2>/dev/null ; then
  curl https://github.com/mrflip/chef/commit/655a1967253a8759afb54f30b818bbcb7c309198.patch | sudo patch $bad_template_file
fi

echo -e "`date` \n\n**** \n**** Installing vagrant keys:\n****\n"
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'http://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub' -O authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

# Installing the virtualbox guest additions
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
cd /tmp
wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt

rm VBoxGuestAdditions_$VBOX_VERSION.iso


echo -e "`date` \n\n**** \n**** Cleanup:\n****\n"
# Remove items used for building, since they aren't needed anymore
apt-get -y remove linux-headers-$(uname -r) build-essential
apt-get -y autoremove

# make locate work good
updatedb

# Ignore the harmless 'no space left on device' error
echo "Zero out the free space to save space in the final image:"
( dd if=/dev/zero of=/EMPTY bs=1M 2>/dev/null ) || true
rm -f /EMPTY

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm /var/lib/dhcp*/*

# Make sure Udev doesn't block our network
# http://6.ptmc.org/?p=164
echo "cleaning up udev rules"
rm /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm /lib/udev/rules.d/75-persistent-net-generator.rules

echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces

echo -e "`date` \n\n**** \n**** Cluster Chef client bootstrap complete\n****\n"
exit
