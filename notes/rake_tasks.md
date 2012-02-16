

Rake Tasks
==========

The homebase contains a `Rakefile` that includes tasks that are installed with the Chef libraries. To view the tasks available with in the homebase with a brief description, run `rake -T`.

Besides your `~/.chef/knife.rb` file, the Rakefile loads `config/rake.rb`, which sets:

* Constants used in the `ssl_cert` task for creating the certificates.
* Constants that set the directory locations used in various tasks.

If you use the `ssl_cert` task, change the values in the `config/rake.rb` file appropriately. These values were also used in the `new_cookbook` task, but that task is replaced by the `knife cookbook create` command which can be configured below.

The default task (`default`) is run when executing `rake` with no arguments. It will call the task `test_cookbooks`.

The following standard chef tasks are typically accomplished using the rake file:

* `bundle_cookbook[cookbook]` - Creates cookbook tarballs in the `pkgs/` dir.
* `install` - Calls `update`, `roles` and `upload_cookbooks` Rake tasks.
* `ssl_cert` - Create self-signed SSL certificates in `certificates/` dir.
* `update` - Update the homebase from source control server, understands git and svn.
* `roles` - iterates over the roles and uploads with `knife role from file`.

Most other tasks use knife: run a bare `knife cluster`, `knife cookbook` (etc) to find out more.
