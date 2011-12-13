## vendor/ -- actual checkouts of cookbooks &c

* `infochimps/` - cookbooks maintained by infochimps (either originated us or heavily modified)
* `opscode/`    - the opscode community cookbooks collection. By default a git submodule checkout of http://gitinfochimps-lab
* `{other}/`    - other independently-maintained cookbooks are submoduled according to their origin.

Here is the workflow we use:

* fork the repo to infochimps-cookbooks. For example, https://github.com/mathie/chef-homebrew is forked to https://github.com/infochimps-cookbooks/chef-homebrew
* git subtree the repo into `vendor/{username}/{repo_name}`.  Don't repair the name -- in this case, call it `vendor/mathie/chef-homebrew`.
* create a symlink to it in `cookbooks/{component_name}` -- in this case, `cookbooks/homebrew` points to `../vendor/mathie/chef-homebrew`.

All of the cookbooks you see here are those infochimps uses in production at time of commit. After doing a `git submodule update --init`, you can check out your own fork and git will magically track that instead.
