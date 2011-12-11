The provided knife.rb file is not essential to use cluster_chef, but has proven exceedingly useful if your workflow involves either multiple chef servers or multiple clouds. We use vagrant to develop cookbooks and the cloud to deploy them. This setup organizes public / private credentials and shared / specialized config files so that it's easy to keep them secure and DRY.

For more information about configuring Knife, see the [Knife documentation](http://help.opscode.com/faqs/chefbasics/knife).

## For existing users

If you have an existing knife setup, there's no reason to change. Simply add

        cluster_path   [ "#{/path/to/your/homebase}/clusters"  ]

to your `knife.rb` file and start adding clusters there. For everyone else, 

## Set up knife configuration

In your ~/.bashrc (or whatever), add lines

        export CHEF_USER={username}         
        export CHEF_ORGANIZATION={organization}  
        export CHEF_HOMEBASE={homebase}

The source your config file to set those environment variables.

## Credentials

Go to `{homebase}/knife` and duplicate the credentials directory, naming it after your organization:

        cd $CHEF_HOMEBASE/knife 
        cp -rp example $CHEF_ORGANIZATION
        cd $CHEF_ORGANIZATION
        git init ; git add .
        git commit -m "New credentials univers for $CHEF_ORGANIZATION" .
    
subdirectories of `{homebase}/knife` are .gitignored; we recommend you don't check this directory into the same git repo that holds your cookbooks.

## User / Cloud config

If you are an opscode platform user, your `chef_server_url` defaults to `https://api.opscode.com/organizations/#{organization}` -- you don't need to change anything.

Otherwise, open `knife/$CHEF_ORGANIZATION/cloud.rb`. Uncomment and edit the lines for your `chef_server_url` and `validator`. Add any custom cookbook or cluster definition paths here.

## Try it out

You should now be able to use knife:

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



