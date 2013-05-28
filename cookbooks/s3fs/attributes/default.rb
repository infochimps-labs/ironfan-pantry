default[:s3fs][:mounts]      = {} # Hash of mounts (eg. {:s3bucket => :mount_point})
default[:s3fs][:release_url] = 'http://s3fs.googlecode.com/files/s3fs-1.68.tar.gz'
default[:s3fs][:version]     = '1.68'
default[:s3fs][:options]     = [ 'rw', 'nosuid', 'nodev', 'allow_other', 'url=https://s3.amazonaws.com', 'use_cache=/tmp', 'nonempty' ]

