The provided knife.rb file is not essential to use cluster_chef, but has proven exceedingly useful if your workflow involves either multiple Chef Servers or multiple clouds. We use Vagrant to develop cookbooks and the cloud to deploy them. This setup organizes public / private credentials and shared / specialized config files so that it's easy to keep them secure and DRY.

For more information about configuring Knife, see the [Knife documentation](http://wiki.opscode.com/display/chef/Knife).

## For existing users

If you have an existing Knife setup, there's no reason to change. Simply add

        cluster_path   [ "#{/path/to/your/homebase}/clusters"  ]

to your `knife.rb` file and start adding clusters there. 

## For everyone else

### Set up knife configuration

In your ~/.bashrc (or whatever), add lines

**SYANOTE: had to make ~/.bachrc in emacs, with Travis's help**
**SYAFLAG: What could be whatever?  The whatever threw me off.  Is it advisable that I put it in bashrc, or does it matter?  What are potential 'whatevers'?**

        export CHEF_USER={username}         
        export CHEF_ORGANIZATION={organization}  
        export CHEF_HOMEBASE={homebase}

Then source your config file to set those environment variables.

**SYAFLAG: How?  Not necessary to explain?**

So that Knife finds its configuration files, symlink the `{homebase}/knife` directory (the one holding this file) to be your `~/.chef` folder. (Or see the end of the README for alternatives you may prefer)

        ln -sni $CHEF_HOMEBASE/knife ~/.chef

### Credentials

All the keys and settings specific to your organization are held in a separate directory, versioned and distributed independently of the homebase. 

**SYAFLAG: "all the keys...are held in a separate directory...".  What directory?**

To set up your credentials directory, visit `{homebase}/knife` and duplicate the example, naming it {organization}-credentials:

        cd $CHEF_HOMEBASE/knife 
        cp -rp example-credentials $CHEF_ORGANIZATION-credentials
        cd $CHEF_ORGANIZATION-credentials
        git init ; git add .
        git commit -m "New credentials universe for $CHEF_ORGANIZATION" .

**SYAFLAG: Need to make credentials available on a central server. Need keys.  Nate cloned over credentials and moved into my infochimps_test-credentials**


### User / Cloud config

Add your credentials in the following places:

* Organization-specific settings are in `knife/{organization}-credentials/knife-org.rb`:
  - _chef server url_: Uncomment and edit the lines for your `chef_server_url` and `validator`. If you are an opscode platform user, you can skip this step -- your `chef_server_url` defaults to `https://api.opscode.com/organizations/#{organization}` and your validator to `{organization}-validator.pem`.
  - _cloud-specific settings_: if you are targeting a cloud provider, add account information and configuration here. 

* User-specific settings are in `knife/{organization}-credentials/knife-user-{username}.rb`. (You can duplicate and rename the one in `knife/example-credentials/knife-user-example.rb`)
  - for example, if you're using EC2 you should set your access keys:

          Chef::Config.knife[:aws_access_key_id]      = "XXXX"
          Chef::Config.knife[:aws_secret_access_key]  = "XXXX"
          Chef::Config.knife[:aws_account_id]         = "XXXX"
        
* Chef user key in `{credentials_path}/{username}.pem`

* Organization validator key in `{credentials_path}/{organization}-validator.pem`

* If you have existing amazon machines, place their keypairs in `{credentials_path}/ec2_keys` 

## Try it out

You should now be able to use Knife.

        $ export CHEF_ORGANIZATION=cocina 

        $ knife client list
        chef-webui
        cocina-chef_server-0
        cocina-sandbox-0
        cocina-validator
        mrflip

        $ knife cluster list
        +--------------------+---------------------------------------------------+ 
        | cluster            | path                                              |
        +--------------------+---------------------------------------------------+
        | burninator         | /cloud/clusters/burninator.rb                     |
        | el_ridiculoso      | /cloud/clusters/el_ridiculoso.rb                  |
        | elasticsearch_demo | /cloud/clusters/elasticsearch_demo.rb             |
        | hadoop_demo        | /cloud/clusters/hadoop_demo.rb                    |
        | sandbox            | /cloud/clusters/sandbox.rb                        |
        +--------------------+---------------------------------------------------+

That example lists the contents of the chef server on my machine. To target myopscode chef server, I just toggle the environment variable:

        $ CHEF_ORGANIZATION=infochimps knife client list
        
        bonobo-master-0
        bonobo-worker-0
        bonobo-worker-1
        bonobo-worker-2
        gordo-elasticsearch-0
        gordo-elasticsearch-1
        gordo-elasticsearch-2
        infochimps-validator
        nikko-flume-0

## Advanced: alternative ways to use this as your knife config

You can make this directory serve as your knife config in one of these ways. The
choice largely comes down to how you'd like to version your credentials.

* Symlink `{homebase}/knife` to `~/.chef`. The {homebase}/knife directory will
  be versioned along with your repo; each credentials directory is `.gitignore`d
  and versioned on its own.
  
* Duplicate `{homebase}/knife` to your `~/.chef`, and ignore {homebase}/knife
  from then on. In this setup you'd probably version your ~/.chef directory as a
  whole.

* This setup lets you manage multiple clouds without having to dance among
  directories, but you can always specify `--config={homebase}/knife/knife.rb`
  on the commandline, or cd into this directory to do any knif'ing (if there is
  a knife.rb in the current directory knife uses it).

## Standard

Don't want our opinion? You can use cluster_chef with any generic knife.rb file. If you're using the Opscode Platform, you can download one for your organization from the management console. If you're using the Open Source Chef Server, you can generate a new one with `knife configure`. 
