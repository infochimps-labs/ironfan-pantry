# volumes chef cookbook

Mounts volumes as directed by node metadata. Can attach external cloud drives, such as ebs volumes.

## Overview

This is a set of simple helpers for assigning components their locations on disk according to these common use cases:

* standard directories: configuration, logs, lib files, etc. These are all the same, or should be.
* directory is not a standard pattern, but follows conventions that let us configure it from node metadata.
* directory prefers to be on the fastest-available drive, or a dedicated drive, or one that is persisted over the network.

### standard_dir

Most directories are **standard and boring**: `conf_dir`s go in `/etc/foo` and are `root:root 755`; `log_dir`s go in `/var/log/foo` and are `{user}:{group} 755`, and so forth. These DRY right up using the `standard_dirs` helper:

        standard_dirs('lolcat.generator') do
          directories   [:conf_dir, :log_dir, :pid_dir]
        end

  This doesn't just save keystrokes, it saves pager calls: the recipe is simpler to read (and thus maintain); it ensures the node metadata completely documents the state of the machine; and it wards off common pitfalls like "configuration dirs owned by the daemon user".

  Standard directories don't have to be _completely_ devoid of individual character:

        standard_dirs('lolcat.generator') do
          directories   [:conf_dir, :html_cache_dir, :img_cache_dir, :log_dir, :pid_dir]
        end

  Both the `html_cache` and `rendered_cache` directories will follow cache directory conventions.

### extra_dir

If you can't be boring, you should at least be **tastefully decorated**. Suppose your lolcat cookbook needs a 'caturday' directory (owned by the lolcat process, mode 0770) and a 'bukkit' directory (permissions `root:root 755`):

        extra_dir(lolcat.generator.caturday_dir') do
          user          :user
          group         :group
        end

        extra_dir(lolcat.generator.bukkit_dir')

  The `extra_dir` helper pulls its settings from the conventional node metadata (`node[:lolcat][:user]` `node[:lolcat][:generator][:caturday_dir]` and so forth), and falls back to conservative defaults.

### volume_dirs

Lastly, some directory assignments -- typically the ones that relate to the machine's core purpose -- are **opinionated guests**.

When my grandmother comes to visit, she quite reasonably asks for a room with a comfortable bed and a short climb. At my apartment, she stays in the main bedroom and I use the couch. At my brother's house, she enjoys the downstairs guest room.  If Ggrandmom instead demanded 'the master bedroom on the first floor', she'd find herself in the parking garage at my apartment, and uninvited from returning to visit my brother's house.

Similarly, the well-mannered cookbook does not hard-code a large data directory onto the root partition. Typically that's the private domain of the operating system, and there's a large and comfortably-appointed volume just for it to use. On the other hand, declaring a location of `/mnt/external2` will end in tears if I'm testing the cookbook on my laptop, where no such drive exists.

The solution is to request for volumes by their characteristics, and defer to the node's best effort in meeting that request.


        # Data striped across all persistent dirs
        volume_dirs('foo.datanode.data') do
          type          :persistent, :bulk, :fallback
          selects       :all
          mode          "0700"
        end

        # Scratch space for indexing, striped across all scratch dirs
        volume_dirs('foo.indexer.scratch') do
          type          :local, :bulk, :fallback
          selects       :all
          mode          "0755"
        end


These are commonly-used volume characteristic tags:

* **fast**:       the 'fastest' volume available: on one machine this might be a dedicated SD drive or even a RAM drive; on another it might be the hey-its-the-only-drive-I-got drive.
* **bulk**:       large storage area, preferably one that does not compete with the OS for space or access.
* **local**:      low-latency / direct access.
* **persistent**: storage that survives independently of its host machine
* **fallback**:   states it's safe to use a general-purpose volume if no better match is present.

All of the above are positive rules: a volume is only `:fast` if it is labeled `:fast`. They are also passive rules: the cookbook makes no attempt to decide that say flash drives are `:fast` (it might be the SD card from my camera) or that a large drive is `:bulk` (it might be full, or read-only).

The `fallback` tag has additional rules:
* if any volumes are tagged `fallback`, return the full set of `fallback`s;
* otherwise, raise an error.

#### Examples:

* Web server: in production, database lives on one volume, logs are written to another. On a cheaper test server, just
  put them whereever.

* Isolate different apps, each on their own volume

* Hadoop has the following mountable volume concerns:

  - Namenode metadata -- *must* be persistent. Physical clusters typically mirror to one NFS and two local volumes.
  - Datanode blocks   -- typically persistent. In a cloud environment, one strategy would be:
    - where available, permanent attachable drives (EBS volumes)
    - where available, local volumes (ephemeral drives)
    - as a last resort, whatever's present.
  - Scratch space for jobs -- should be fast, no need for it to be persistent.  On an EC2 instance, ephemeral drives
    would be preferred.

* Similarly, a Cassandra installation will place the commitlog the fastest available volume, the data store on the most
  persistent available volume. A Mongo or MySQL admin may allocate high-demand tables on an SSD, the rest on normal disks.

You ask for volume_dirs with
* a system
* a component (optional)
* a tag

We will look as follows:

* volumes tagged 'foo-
* volumes tagged 'foo-scratch'
* volumes tagged 'foo'
* volumes tagged 'scratch'

Write your recipes to request volumes


Not doing this:

        standard_dirs('lolcat.generator') do
          conf_dir
          log_dir       :mode => '0775'
          pid_dir
          cache_dir     :for => :img
          cache_dir     :for => :html
        end



### assigning labels

Labels are assigned by a human using (we hope) good taste -- there's no effort,
nor will there be, to presuppose that flash drives are `fast` or large drives
are `bulk`.  However, the cluster_chef provisioning tools do lend a couple
helpers:

* `cloud(:ec2).defaults` describes a `:root`
  - tags it as `fallback`
  - if it is ebs, tags it
  - does *not* marks it as `mountable`

* `cloud(:ec2).mount_ephemerals` knows (from the instance type) what ephemeral
  drives will be present. It:
  - populates volumes `ephemeral0` through (up to) `ephemeral3`
  - marks them as `mountable`
  - tags them as `local`, `bulk` and `fallback`
  - *removes* the `fallback` tag from the `:root` volume. (So be sure to call it *after*
    calling `defaults`.

You can explicitly override any of the above.


### examples


* Hadoop namenode metadata:
  - `:hadoop_namenode`
  - `:hadoop`
  - `[:persistent, :bulk]`
  - `:bulk`
  - `:fallback`



    System       	Component      	Type	Path           	Owner         	Mode 	Index 	attrs                          	Description
    ------       	---------      	----	----           	-----         	---- 	----- 	-----                          	-----------

topline

    hadoop      	dfs_name       	perm	hdfs/name      	hdfs:hadoop  	0700	all	[:hadoop][:namenode   ][:data_dirs]
    hadoop      	dfs_2nn        	perm	hdfs/secondary 	hdfs:hadoop  	0700	all	[:hadoop][:secondarynn][:data_dirs]    	dfs.name.dir
    hadoop      	dfs_data       	perm	hdfs/data      	hdfs:hadoop  	0755	all	[:hadoop][:datanode   ][:data_dirs]    	dfs.data.dir
    hadoop      	mapred_local   	scratch	mapred/local   	mapred:hadoop	0775	all	[:hadoop][:tasktracker][:scratch_dirs] 	mapred.local.dir
    hadoop      	log      	scratch	log      	hdfs:hadoop	0775	first	[:hadoop][:log_dir]                	mapred.local.dir
    hadoop      	tmp      	scratch	tmp      	hdfs:hadoop	0777	first	[:hadoop][:tmp_dir]              	mapred.local.dir

    hbase       	zk_data  	perm	zk/data  	hbase    	0755	first	[:hbase][:zk_data_dir]  	.
    hbase          	tmp      	scratch	tmp      	hbase    	0755	first	[:hbase][:tmp_dir]       	.

    zookeeper       	data     	perm	data     	zookeeper	0755	first	[:zookeeper][:data_dir]     	.
    zookeeper       	journal  	perm	journal  	zookeeper	0755	first	[:zookeeper][:journal_dir]  	.

    elasticsearch 	data    	perm	data      	elasticsearch  	0755	first	[:elasticsearch][:data_root]	.
    elasticsearch 	work    	scratch	work      	elasticsearch  	0755	first	[:elasticsearch][:work_root]  	.

    cassandra       	data    	perm	data     	cassandra   	0755	all	[:cassandra][:data_dirs]
    cassandra         	commitlog     	scratch	commitlog	cassandra   	0755	first	[:cassandra][:commitlog_dir]
    cassandra         	saved_caches   	scratch	saved_caches	cassandra   	0755	first	[:cassandra][:saved_caches_dir]

    flume       	conf    	.
    flume       	pid     	.
    flume        	data     	perm	data         	flume
    flume        	log      	scratch	data       	flume

    zabbix
    rundeck

    nginx
    mongodb

    scrapers      	data_dir
    api_stack    	.
    web_stack

hold

    redis       	data_dir
    redis          	work_dir
    redis        	log_dir

    statsd      	data_dir
    statsd      	log _dir

    graphite          	whisper  	perm
    graphite          	carbon   	perm
    graphite          	log_dir  	perm

    mysql
    sftp
    varnish
    ufw

kill

    tokyotyrant
    openldap
    nagios
    apache2
    rsyslog

### Memoized

Besides creating the directory, we store the calculated path into

  node[:system][:component][:handle]

## Recipes 

* `build_raid`               - Build a raid array of volumes as directed by node[:volumes]
* `default`                  - Placeholder -- see other recipes in ec2 cookbook
* `format`                   - Format the volumes listed in node[:volumes]
* `mount`                    - Mount the volumes listed in node[:volumes]
* `resize`                   - Resize mountables in node[:volumes] to fill the volume

## Integration

Supports platforms: debian and ubuntu

Cookbook dependencies:
* metachef
* xfs


## Attributes

* `[:volumes]`                        - Logical description of volumes on this machine (default: "{}")
  - This hash maps an arbitrary name for a volume to its device path, mount point, filesystem type, and so forth.
    
    volumes understands the same arguments at the `mount` resource (nb. the prefix on `options`, `dump` and `pass`):
    
    * mount_point    (required to mount drive) The directory/path where the device should be mounted, eg '/data/redis'
    * device         (required to mount drive) The special block device or remote node, a label or an uuid to mount, eg '/dev/sdb'. See note below about Xen device name translation.
    * device_type    The type of the device specified -- :device, :label :uuid (default: `:device`)
    * fstype         The filesystem type (`xfs`, `ext3`, etc). If you omit the fstype, volumes will try to guess it from the device.
    * mount_options  Array or string containing mount options (default: `"defaults"`)
    * mount_dump     For entry in fstab file: dump frequency in days (default: `0`)
    * mount_pass     For entry in fstab file: Pass number for fsck (default: `2`)
    
    
    volumes offers special helpers if you supply these additional attributes:
    
    * :scratch       if true, included in `scratch_volumes` (default: `nil`)
    * :persistent    if true, included in `persistent_volumes` (default: `nil`)
    * :attachable    used by the `ec2::attach_volumes` cookbook.
    
    Here is an example, typical of an amazon m1.large machine:
    
      node[:volumes] = { :volumes => {
          :scratch1 => { :device => "/dev/sdb",  :mount_point => "/mnt", :scratch => true, },
          :scratch2 => { :device => "/dev/sdc",  :mount_point => "/mnt2", :scratch => true, },
          :hdfs1    => { :device => "/dev/sdj",  :mount_point => "/data/hdfs1", :persistent => true, :attachable => :ebs },
          :hdfs2    => { :device => "/dev/sdk",  :mount_point => "/data/hdfs2", :persistent => true, :attachable => :ebs },
        }
      }
    
    It describes two scratch drives (fast local storage, but wiped when the machine is torn down) and two persistent drives (network-attached virtual storage, permanently available).
    
    Note: On Xen virtualization systems (eg EC2), the volumes are *renamed* from /dev/sdj to /dev/xvdj -- but the amazon API requires you refer to it as /dev/sdj.
    
    If the `node[:virtualization][:system]` is 'xen' **and** there are no /dev/sdXX devices at all **and** there are /dev/xvdXX devices present, volumes will internally convert any device point of the form `/dev/sdXX` to `/dev/xvdXX`. If the example above is a Xen box, the values for :device will instead be `"/dev/xvdb"`, `"/dev/xvdc"`, `"/dev/xvdj"` and `"/dev/xvdk"`.
    
* `[:metachef][:aws_credential_source]` -  (default: "data_bag")
  - where should we get the AWS keys?
* `[:metachef][:aws_credential_handle]` -  (default: "main")
  - the key within that data bag

## License and Author

Author::                Philip (flip) Kromer - Infochimps, Inc (<coders@infochimps.com>)
Copyright::             2011, Philip (flip) Kromer - Infochimps, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

> readme generated by [cluster_chef](http://github.com/infochimps/cluster_chef)'s cookbook_munger
