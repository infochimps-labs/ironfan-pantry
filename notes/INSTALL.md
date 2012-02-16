# Ironfan Installation Instructions

Every Chef installation needs a Chef Homebase. Chef Homebase is the place where cookbooks, roles, config files and other artifacts for managing systems with Chef will live. We strongly advise you to store this homebase in a version control system such as Git and to treat it like source code.

### Conventions

In all of the below,

* `{homebase}`: the directory that holds your chef cookbooks, roles and so forth. For example, this file is in `{homebase}/README.md`.

* `{username}` identifies your personal chef client name: the thing you use to log into the chef WebUI.

* `{organization}`: identifies the credentials set and cloud settings to use.  If your chef server is on the Opscode platform (try it! it's super-easy), use your organization name (the last segment of your chef_server url). If not, use an identifier you deem sensible.

Installation
============

** @sya -- while doing your runthrus, first do:

       rvm gemset create testing
       rvm gemset use    testing
       gem list                  # will show nearly nothing
       gem install bundler
       # now carry on with the instructions.

Before you start, you may wish to fork the repo as you'll be making changes to personalize it for your platform.

1. Clone the repo. It will produce the directory we will call `homebase` from now on:

        git clone https://github.com/infochimps-labs/ironfan-homebase homebase
        cd homebase
        git submodule update --init
        # optional: set each submodule to its master branch
        git submodule foreach git checkout master

2. Install the ironfan gem (you may need to use `sudo`):

        gem install ironfan

3. Set up your [knife.rb](http://help.opscode.com/faqs/chefbasics/knife) file.

  - _New to Chef_: If you don't have an existing chef setup, follow steps in
   [knife/README.md](https://github.com/sya/ironfan-homebase/blob/master/knife/README.md)
   to set up `~/.chef` and its credentials (`knife/{organization}-credentials`)
   folder. By default, we assume your chef-server username is `$USER` and the 
   homebase is the parent directory of your knife.rb, but you can customize 
   them by setting either or both of these environment variables:

        export CHEF_USER={username} CHEF_HOMEBASE={homebase}

  - _Have a knife.rb_: add these lines to your knife.rb:

        # your organization name
        organization   '{organization}' 
        # path to your cluster definitions:
        cluster_path   [ "#{/path/to/your/homebase}/clusters" ]

5. You should now be able to `knife cluster list`, to see all the clusters available:

        $ knife cluster list
        +--------------------+-------------------------------------------+
        | cluster            | path                                      |
        +--------------------+-------------------------------------------+
        | burninator         | /cloud/clusters/burninator.rb             |
        | el_ridiculoso      | /cloud/clusters/el_ridiculoso.rb          |
        | elasticsearch_demo | /cloud/clusters/elasticsearch_demo.rb     |
        | hadoop_demo        | /cloud/clusters/hadoop_demo.rb            |
        | sandbox            | /cloud/clusters/sandbox.rb                |
        +--------------------+-------------------------------------------+

   If that doesn't work -- if it instead gives you a way-too-long list of knife commands -- then knife did not find the ironfan plugins. Check [HEY SELENE PLEASE LINK TO KNIFE PLUGINS ON CHEF WIKI] for more.

6. Launching a cluster in the cloud should now be this easy!

        knife cluster launch sandbox:simple --bootstrap

__________________________________________________________________________


The provided knife.rb file is not essential to use ironfan, but has proven exceedingly useful -- it leaves you in good shape to avoid problems with credential management, importing 3rd-party cookbooks, and other things down the road.

For more information about configuring Knife, see the [Knife documentation](http://wiki.opscode.com/display/chef/Knife).

## Standard

You can use ironfan with any generic knife.rb file. If you're using the Opscode Platform, you can download one for your organization from the management console. If you're using the Open Source Chef Server, you can generate a new one with `knife configure`.

## For existing users

If you have an existing Knife setup, there's no reason to change. Simply add

        cluster_path   [ "#{/path/to/your/homebase}/clusters"  ]

to your `knife.rb` file and start adding clusters there. 

## For everyone else

### Set up knife configuration

In your ~/.bashrc (or whatever), add lines

**SYANOTE: had to make ~/.bachrc in emacs, with Travis's help**
**SYAFLAG: What could be whatever?  The whatever threw me off.  Is it advisable that I put it in bashrc, or does it matter?  What are potential 'whatevers'?**
**@sya these are now optional, fixed this in INSTALL.md**


        export CHEF_USER={username}         
        export CHEF_HOMEBASE={homebase}

Then source your config file to set those environment variables.

**SYAFLAG: How?  Not necessary to explain?**

So that Knife finds its configuration files, symlink the `{homebase}/knife` directory (the one holding this file) to be your `~/.chef` folder.

        ln -sni $CHEF_HOMEBASE/knife ~/.chef

### Credentials

All the keys and settings specific to your organization are held in a directory named `credentials/`, versioned and distributed independently of the homebase. 

To set up your credentials directory, visit `{homebase}/knife` and duplicate the example, naming it `credentials`:

        cd $CHEF_HOMEBASE/knife 
        rm credentials
        cp -rp example-credentials credentials
        cd credentials
        git init ; git add .
        git commit -m "New credentials universe for $CHEF_ORGANIZATION" .
        
### User / Cloud config

Edit the following places in your new `credentials`:

* Organization-specific settings are in `knife/{organization}-credentials/knife-org.rb`:
  - _organization_:             Your organization name (@sya)
  - _chef server url_:          Edit the lines for your `chef_server_url` and `validator`. If you are an opscode platform user, you can skip this step -- your `chef_server_url` defaults to `https://api.opscode.com/organizations/#{organization}` and your validator to `{organization}-validator.pem`.
  - _cloud-specific settings_: if you are targeting a cloud provider, add account information and configuration here. 

* User-specific settings are in `knife/credentials/knife-user-{username}.rb`. (You can duplicate and rename the one in `knife/example-credentials/knife-user-example.rb`)
  - for example, if you're using EC2 you should set your access keys:

          Chef::Config.knife[:aws_access_key_id]      = "XXXX"
          Chef::Config.knife[:aws_secret_access_key]  = "XXXX"
          Chef::Config.knife[:aws_account_id]         = "XXXX"
        
* Chef user key in `{credentials_path}/{username}.pem`

* Organization validator key in `{credentials_path}/{organization}-validator.pem`

* If you have existing amazon machines, place their keypairs in `{credentials_path}/ec2_keys` 

__________________________________________________________________________

## Try it out

You should now be able to use Knife.

        $ knife client list
        chef-webui
        cocina-chef_server-0
        cocina-sandbox-0
        cocina-validator

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

__________________________________________________________________________


### Next

The README file in each of the subdirectories for more information about what goes in those directories. But you are probably bored of reading. Go customize one of the files in the clusters/ directory. Or, if you're a fan of ridiculous things and have ever wondered how many things you can fit on one box, launch `el_ridiculoso`:

        knife cluster launch el_ridiculoso:grande --bootstrap


**@sya please put the following where it goes**:


To get started with knife and chef, follow the "Chef Quickstart,":http://wiki.opscode.com/display/chef/Quick+Start We use the hosted chef service and are very happy, but there are instructions on the wiki to set up a chef server too. Stop when you get to "Bootstrap the Ubuntu system" -- cluster chef is going to make that much easier.

* [Launch Cloud Instances with Knife](http://wiki.opscode.com/display/chef/Launch+Cloud+Instances+with+Knife)
* [EC2 Bootstrap Fast Start Guide](http://wiki.opscode.com/display/chef/EC2+Bootstrap+Fast+Start+Guide)  **wow, we do everything on that page in one command**

