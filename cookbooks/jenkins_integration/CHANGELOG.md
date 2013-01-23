# CHANGELOG for jenkins_integration

This file is used to list changes made in each version of jenkins_integration.

## 0.1.10:
* sync_changes.sh uploads only changed cookbooks
* cleaning up comments, default :branch and :merge for pantries
* dropping htmlentities (no longer necessary)
* cleaning up reporting, bundler execution

## 0.1.9:
* Adding merge to staging on stage_* steps

## 0.1.8:
* Mock change, to test final setup

## 0.1.7:
* Switching to crippled sync_changes.sh (instead of 1/2 hr full_sync.sh)

## 0.1.6:
* Expanded config templating to handle chaining of jobs
* Included required plugins (run jenkins::plugins *after* ironfan_ci)
* Added parameterization of chained jobs

## 0.1.5:
* Switched to templating for tasks (instead of inline string)
* Cleaning up knife_shared.inc usage

## 0.1.0:
* Initial release of jenkins_integration

- - - 
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
