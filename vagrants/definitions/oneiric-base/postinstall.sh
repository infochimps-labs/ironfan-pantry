# postinstall.sh created from Mitchell's official lucid32/64 baseboxes

eval `cat /etc/lsb-release `
export DEBIAN_FRONTEND=noninteractive

date > /etc/vagrant_box_build_time

echo -e "`date` \n\n**** \n**** Installing base packages:\n****\n"
# Apt-install various things necessary for Ruby, guest additions,
# etc., and remove optional things to trim down the machine.
apt-get -y update
apt-get -y upgrade
apt-get -y install linux-headers-$(uname -r) build-essential
apt-get -y install zlib1g-dev libssl-dev libreadline5
apt-get -y install libc6-dev libmysql++-dev libsqlite3-dev make libreadline5-dev zlib1g-dev
apt-get -y install wget curl runit runit-services openssl libcurl4-openssl-dev libxml2-dev libyaml-dev libxslt-dev
apt-get clean

# source for sun java if you want to install it later
apt-get install -y python-software-properties
add-apt-repository ppa:ferramroberto/java
apt-get -y update

# Setup sudo to allow no-password sudo for "admin"
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

# Install NFS client
apt-get -y install nfs-common

if [ -f /usr/bin/chef-client ]; then
  echo -e "`date` \n\n**** \n**** Chef is present -- skipping apt/ruby/chef installation\n****\n"
else # no chef-client

RUBY_VERSION=1.9.2-p290
echo -e "`date` \n\n**** \n**** Installing ruby version ${RUBY_VERSION}:\n****\n"

mkdir -p /usr/local/{src,share}
cd /usr/local/share

wget ftp://ftp.ruby-lang.org//pub/ruby/1.9/ruby-${RUBY_VERSION}.tar.gz -O /usr/local/src/ruby-${RUBY_VERSION}.tar.gz
tar xzf /usr/local/src/ruby-${RUBY_VERSION}.tar.gz
cd ruby-${RUBY_VERSION}
./configure --with-ruby-version=${RUBY_VERSION} --prefix=/usr --program-suffix=${RUBY_VERSION}
make -j2
make install

sudo update-alternatives --remove-all gem && true
update-alternatives \
  --install /usr/bin/ruby ruby /usr/bin/ruby${RUBY_VERSION} 400 \
  --slave   /usr/bin/ri   ri   /usr/bin/ri${RUBY_VERSION}       \
  --slave   /usr/bin/irb  irb  /usr/bin/irb${RUBY_VERSION}      \
  --slave   /usr/bin/erb  erb  /usr/bin/erb${RUBY_VERSION}      \
  --slave   /usr/bin/gem  gem  /usr/bin/gem${RUBY_VERSION}      \
  --slave   /usr/share/man/man1/ruby.1.gz ruby.1.gz             \
  /usr/share/man/man1/ruby${RUBY_VERSION}.1

if ruby -e "exit(%x{gem --version} < \"1.6.2\" ? 0 : -1 )" ; then
  echo -e "`date` \n\n**** \n**** Updating rubygems:\n****\n"
  gem update --system
  # screw you rubygems
  for foo in /usr/lib/ruby/site_ruby/*/rubygems/deprecate.rb ; do sudo sed -i.bak 's!@skip ||= false!true!' "$foo" ; done
fi

echo -e "`date` \n\n**** \n**** Installing chef:\n****\n"
gem install ohai --no-rdoc --no-ri
gem install chef --no-rdoc --no-ri --version=0.10.04
gem install      --no-rdoc --no-ri bundler cheat pry

fi # end ruby+chef install

# fix a bug in chef that prevents debugging template errors
bad_template_file='/usr/lib/ruby/gems/1.9.2-p290/gems/chef-0.10.4/lib/chef/mixin/template.rb'
if  echo "0505c482b8b0b333ac71bbc8a1795d19  $bad_template_file" | md5sum -c - 2>/dev/null ; then
  curl https://github.com/mrflip/chef/commit/655a1967253a8759afb54f30b818bbcb7c309198.patch | sudo patch $bad_template_file
fi

# echo -e "`date` \n\n**** \n**** First run of chef:\n****\n"
# set -e
# chef-client
# set +e

echo -e "`date` \n\n**** \n**** Cleanup:\n****\n"
updatedb

# Installing vagrant keys
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

# Remove items used for building, since they aren't needed anymore
apt-get -y remove linux-headers-$(uname -r) build-essential
apt-get -y autoremove

# Zero out the free space to save space in the final image:
echo "Ignore the harmless 'no space left on device' error"
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm /var/lib/dhcp3/*

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
