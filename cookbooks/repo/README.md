# repo chef cookbook

## Overview

This cookbook sets up an apt, yum, and gem repository (Gem and Yum are a work in progress) mirroring common upstream repositories used in Ironfan.

## Recipes 

* `apache_config`            - Configures Apache to serve the repositories. 
* `default`                  - Creates the 'root' directory for the repositories
* `apt`                      - Sets up the apt repository and mirrors upstream Cloudera and WebUp8 repositories.
* `fpm`                      - Installs the 'fpm' gem to make packing easier
* `keys`                     - Adds the keys required for the upstream repos
* `yum`                      - TODO

## Integration

Cookbook dependencies:

* apache2

Package dependencies: 

* `reprepro`
* `rpm`
* `yum_utils`

## Attributes

* `default[:repo][:root]` - Base location for to hold the repositories (default: /var/packages)
* `default[:repo][:type]` - List of repositories to host (defualt: [ "apt" ])
* `default[:repo][:keys][:cloudera]` - Current key for the Cloudera repositories 
* `default[:repo][:keys][:webupd8team]` - Current key for the webupd8team repositories
* `default[:repo][:apt][:base]` - Base location for apt repository (default: /var/packages/apt)

## Manual Steps
### Signing Apt packages
A few steps at this time are still manual.  The first being to generate the GPG key to sign the packages with (if you chose). 

First, you'll need to generate entropy unless you are local to the machine. 

$ rngd -r /dev/urandom
$ gpg --gen-key # And follow the prompts

You'll then want to export the public key to place somewhere available to the clients (/var/packages/ is where we put ours).

$ gpg --armor --output whatever.gpg.key --export `<key-id>`

In order to sign your packages, override the following attribute : 

* `default[:repo][:apt][:signwith]` = `<key-id>`

### Security groups accross accounts
If you are running more then one AWS account and dont want to run repositories in each account, you can open up the security groups as follows: 

$ ec2-authorize `<your-account-security-group-id>` -P `<protocal>` -p `<port>` -u `<other-aws-account-id>` -o `<other-account-security-group-id>`

See http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/ApiReference-cmd-AuthorizeSecurityGroupIngress.html for more information.

## License and Author

Author::                Brandon Bell - Infochimps, Inc (`<coders@infochimps.com>`)
Copyright::             2013, Brandon Bell - Infochimps, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
