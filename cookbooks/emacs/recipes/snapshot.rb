include_recipe 'apt'

# Add cloudera package repo
apt_repository 'emacs_snapshot' do
  uri             'http://ppa.launchpad.net/cassou/emacs/ubuntu'
  components      ['main']
  keyserver       'keyserver.ubuntu.com'
  key             '8FBB7709281B6E626DD855CF84DBCE2DCEC45805'
  distribution    node[:lsb][:codename]
  action          :add
  notifies        :run, "execute[apt-get-update]", :immediately
end

package('emacs-snapshot-nox'){ action :upgrade }

bash 'emacs snapshot preferred alternative' do
  code %Q{
update-alternatives --set emacs                     /usr/bin/emacs-snapshot
update-alternatives --set ebrowse           /usr/bin/ebrowse.emacs-snapshot
update-alternatives --set emacsclient   /usr/bin/emacsclient.emacs-snapshot
}
  not_if  %Q{update-alternatives --display emacs | egrep -q 'currently points to /usr/bin/emacs-snapshot' }
  action :run
end
