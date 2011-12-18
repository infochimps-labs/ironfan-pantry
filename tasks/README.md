We store and track our cookbooks in two separate repo sets([*](#foot_1)):

* In the [infochimps-cookbooks](http://github.com/infochimps-cookbooks) collection, each in its own repo
* In [cluster_chef-homebase](http://github.com/infochimps-labs/cluster_chef-homebase), each in its own a subdirectory

We've found a way to pull this off well, but ungracefully. Well, thanks to the magic of [git-subtree](https://github.com/apenwarr/git-subtree); ungracefully, due to git-subtree's limitations. Repoman is a set of rake tasks that protect you from those limitations.

Let me explain. No, there is too much. Let me sum up.

* Repoman gives you these commands; replace COOKBOOKNAME with the cookbook to use: 
  - `rake repo:pull[COOKBOOKNAME]` - pulls the _remote version_ of a cookbook _from_ the cookbook-only repo on github _to_ the homebase.
  - `rake repo:push[COOKBOOKNAME]` - pushes the _homebase version_ of a cookbook _to_ the cookbook-only repo on github _from_ the homebase.
  - `rake repo:pull:to_main_from_solo[COOKBOOKNAME]` - pulls the _local solo version_ of a cookbook _from_ the local checkout of the cookbook-only repo _to_ the homebase.
  - `rake repo:pull:to_solo_from_main[COOKBOOKNAME]` - pulls the _homebase version_ of a cookbook _from_ the homebase _to_ the local checkout of the cookbook-only repo.
* Please install [git-subtree](https://github.com/apenwarr/git-subtree) by cloning the repo and running its `./install.sh` script.
* Please also set a few configuration variables in your knife.rb file:
  - `repoman_path`:
  - `github_cookbooks_org`:
  - `github_cookbooks_team`:
* There are other `repo:` commands; don't use them unless you understand their internals.

See below for

* An explanation of why these scripts are necessary
* Detail on the remaining limitations of the git-subtree strategy
* Our still-emerging cookbook publishing workflow
* Further reading

## Why is this necessary? ##

### Unified repos for some, miniature american flags for others ###

Individual cookbook repos make our sysadmins happy: fine-grained version control lets us selectively gate changes into production. As importantly, cluster_chef community members can easily adopt only selected cookbooks, and we can easily evaluate and accept pull requests.

A unified, combined repo makes our developers happy: they have a familiar home to work from, a git repo like every other git repo. After making a common change across multiple cookbooks, they issue a single commit -- one message, one atomic changeset, one diff. There's only one main body of code to push or pull, so there's no danger our working sets diverge or of forgetting to push.

### Git submodules considered soul-sucking ###

Git submodules are annoying coworkers - they get the job done, but always seem to cause unnecessary grief and a mini-crisis when you need it least. One or two of them is tolerable, but I'm here to tell you that by the dozen it's an unworkable cacophanous hell. Detached heads, disconnected commits, git's inability to say whether the submodule change is in the future or past lead to developer frustration, incoherent commit messages, and ultimately commit scripts that present a far greater danger to production than is justifiable.

## git-subtree to the rescue (mostly) ##

Git-subtree lets you push/pull changes to a given subtree (subdirectory and all descendants) with a disconnected repo. Say you give the `runit_service` definition some new superpower (requiring a modest amount of new code). You also make one-line changes adding that superpowe to your awesome_webapp and three other cookbooks and their corresponding roles. You will then make two commits: "Runit services now have rocket engines" (affecting only files in cookbooks/runit), and "Gifted the power of flight to all cookbooks with unicorns" (affecting many files in roles/ and one file in each of three cookbooks/{with_unicorn}). Yay, atomic bundled changes, familiar workflow, life is good.

A `git-subtree push` allows you to syndicates those changes to the individual cookbooks. The runit cookbook sees one new commit, "Runit services now have rocket engines". The individual cookbooks also see one new commit, "Gited the...", changing in each its one affected file. Go to the github page for you/awesome_webapp and you'll see a commit like other commits.

Afterwards, someone tries it out, and submits a patch to `runit`, "Rocket engines no longer explode on launch pad when Spark is installed". You can merge that change into the `runit` cookbook, like any other merge; and your local checkout of the `runit` cookbook can do a pull like any other pull. Finally, a `git-subtree pull` into the main repo changes the affected files in the `runit` cookbook subdirectory, even if there are intervening commits to runit or elsewhere. Unfortunately this is not a pull like any other pull.. more shortly.

### what's great about git-subtree ###

What's great about git-subtree's magic is that it is *not* magic. It's a shell script on top of core git commands. It's not rewriting patches, peeking into blobs, or meddling with dark forces that could go crazy and destroy Tokyo. You get all the power of git's [inflexibility](http://softwareswirl.blogspot.com/2009/08/git-mercurial-and-bazaarsimplicity.html), speed, fingerprints, and all the rest.

### what's not-so-great about git-subtree ###

* _the weird shadow universe it creates_: A git-subtree pull is not a pull like any other pull. Say the `recipes/rocket.rb` file in the `runit` cookbook is changed. A `git log` in that repo shows changes to `recipes/rocket.rb` just as you expect. Pull that change into your homebase, modifying `cookbooks/runit/rocket.rb`. A `git log` now shows changes to... `recipes/rocket.rb`. Huh? Well, git-subtree is just a layer on top of normal git (that's what we love). There's really only the one commit with the one SHA having a commit message about recipes/rocket.rb. We pull it in with a special type of merge, one that uses the 'subtree merge' strategy. I've written much, much more about (what I understand) is going on below... 

* _commitlog messages are screwy_: because of that weird shadow universe, you can't just run `git log -p vendor/infochimps/redis` to see the history of changes to the redis cookbook. Instead, run

    git log -p -m --first-parent -- vendor/infochimps/redis

* _splits are really, really slow_: Actually they're just slow, but since everything else in git is fast it's a glaring difference.

* _merge conflicts get much more delicate_: ...hence this set of scripts

## Our Workflow, and the Repoman Tools ##

We want to coordinate the following:

* github   - remote repos, one for each cookbook (eg https://github.com/infochimps-cookbooks/redis)
* homebase - a homebase with each cookbook in its own subdirectory (eg vendor/infochimps/redis; presumably the homebase is a clone of [cluster_chef-homebase](http://github.com/infochimps-labs/cluster_chef-homebase) or [opscode's homebase](http://github.com/opscode/chef-repo))

Nothing that follows prevents you from `git subtree push`/`pull`ing directly to and from the remote. But if you're like most of us -- who understand only push, pull, merge, and `--help` -- these scripts ensure that when git catches on fire it only does so in a safe familiar place. What we do is also set up

* solo - clone of each cookbook repo in `repoman/{cookbook_name}`, eg `~/dev/repoman/redis`. This is a regular clone that looks just like what you see on github.
* br-{cookbook} - a dedicated branch, inside the homebase, that looks just like what you see on github.

All pushes and pulls are staged through the solo clone. Everything that happens in the solo clone is a good old-fashioned pull, either from the github remote or from the dedicated branch. You have all your familiar comforts (`git log`, `git diff`) and means of brute force (rsync, `git reset --hard`, nuking it from orbit).

### Repoman's basic commands

* `rake repo:pull[COOKBOOKNAME]` - pulls the _remote version_ of a cookbook _from_ the cookbook-only repo on github _to_ the homebase.
* `rake repo:push[COOKBOOKNAME]` - pushes the _homebase version_ of a cookbook _to_ the cookbook-only repo on github _from_ the homebase.
* `rake repo:pull:to_main_from_solo[COOKBOOKNAME]` - pulls the _local solo version_ of a cookbook _from_ the local checkout of the cookbook-only repo _to_ the homebase.
* `rake repo:pull:to_solo_from_main[COOKBOOKNAME]` - pulls the _homebase version_ of a cookbook _from_ the homebase _to_ the local checkout of the cookbook-only repo.

### Repoman en bulk

* `rake repo:pull:all` - invokes `rake repo:pull[]` on every cookbook.
* `rake repo:push:all` - invokes `rake repo:push[]` on every cookbook.

### Repoman Setup

TODO: Repoman setup


## Fathomably Askable Questions ##

Q: **Are you *sure* there isn't a better way?**

Far from it. I still don't understand the `--rejoin` or `--onto` git subtree options 

Here's something that doesn't work, but maybe someone can tweak:

* Create a cookbook-only repo that you submodule (yuck) into the `cookbooks/` folder in your homebase. 
* In the cookbooks repo, files for the foo cookbook live in `foo/{files}`; there are lots of subfolders in the base of the repo.
* In the solo repo,      files for the foo cookbook live in `foo/{files}`; there is only one folder, `foo/`, in the base of the repo.
* Now all the git commits look the same...
* ...but the result is baffling for anyone else in the world: after git clone'ing or git submodule'ing the foo repo, the cookbook files are in `foo/foo/{files}`.
* ...and anyway git-subtree only goes subtree to root (`foo/{files} <=> {files}`), not subtree to subtree (`foo/{files} <=> foo/{files}`).

Other things that don't work:

* two dozen git submodules: *shudder* (see section elsewhere in this README).
* something something modified patches something: Linus invented git for a reason -- you're giving up the unified history, idempotent SHAs, etc.
* something something rsync something: now you not only don't have unified history, you don't even have unified commit messages.

Q: **Why not use the --squash option?**

A: It runs the wrong way. `git-subtree squash` is used best for a main project that includes a mostly-independent subcomponent. In this case, changes to the subtree happen in its own repo, and the main project makes quantum transitions in version. From the git-subtree docs:

> "People rarely want to see every change that happened between v1.0 and v1.1 of the library they're using, since none of the interim versions were ever included in their application."

However, we find it most productive to make changes in the unified tree and syndicate them *out* to the subtree repo. It's valuable to see full commit messages in each place (enough to tolerate the duplicated-message thing)

## Advanced: How git-subtree works ##

_(To follow along, clone [cluster_chef-homebase](http://github.com/infochimps-labs/cluster_chef-homebase) and rename it 'homebase'; also create a neighboring directory called 'repoman' and clone  [infochimps-cookbooks's redis repo](http://github.com/infochimps-cookbooks/redis) into a directory `repoman/redis`.)_

Here is the principal component of the Git Tao ([*](#foot_2)):

> git is jus a set of commits and references (local/remote branches and tags),
> and [references make commits reachable](http://bit.ly/thinklikeagit)

If you use git regularly, I'm sure at some point you added the wrong remote to your repo and saw the "warning: no common commits" on first fetch.  Git will quite happily drag in all commits from any other repo. You could conceivably keep every project you maintain in a single repo with a single `.git/` folder, and I'm sure there's a neckbeard out there going "Yes!  and it's so much simpler!". ... yeahhh.

Anyway, while we think of some commits as direct commits to `homebase`, and others as imported commits to `redis`, really they're just commits, because that's all git is: commits (and references, which make commits reachable).

### Anatomy of a rake repo:push ###

**Step 1** in a `rake repo:push[redis]` is

    cd       $homebase_dir
    git subtree split -P vendor/infochimps/redis -b br-redis
    
This recapitulates commits from the solo `redis` repo into its own branch, named 'br-redis' (so tab-completion still works). Tug on that reference with `git checkout br-redis` and you'll see a duplicate of the solo `redis` repo, right there in the homebase directory, with none of the files from `homebase` in sight. Yikes! Run `git checkout master` to teleport back from bizarro krypton -- you should see the full homebase back again.

**Step 2** Next we make the solo repo look just like github does:

    cd       $repoman_dir/redis
    git pull origin master

There's absolutely nothing fancy here, it's a pull like you're familiar with.

**Step 3** is to pull from the homebase's 'br-redis' branch to the solo repo:

    cd       $repoman_dir/redis
    git pull $homebase_dir/.git  br-redis:master

This does two weird things, but they're only a tiny little bit weird:
* it refers directly to the .git directory. This does just what you'd expect, which is treat all its committed changes like a normal git repo. 
* The last part of the pull command is `br-redis:master`. This means "merge the `br-redis` branch from there into the `master` branch here". 
Otherwise, it's just the fetch-remote-changes-and-merge you know and love.

Any merge conflict will happen right here, so this is where you should go to sort it out.

**Step 4** pushes from the solo repo to github:

    cd       $repoman_dir/redis
    git push origin master
    
Again, absolutely nothing fancy here, it's a push like you're familiar with, from this repo's master branch to the remote's master branch.

### Anatomy of a rake repo:pull ###

**Step 1**: in `rake repo:pull[redis]` is to sync homebase into solo:

    cd       $homebase_dir
    git subtree split -P vendor/infochimps/redis -b br-redis

    cd       $repoman_dir/redis
    git pull $homebase_dir/.git br-redis:master

**Step 2**: pull from github:

    cd       $repoman_dir/redis
    git pull origin master

If a merge conflict were to occur, this is where it would happen.

**Step 3**: pull from solo into the cookbook's branch in homebase:

    cd       $homebase_dir
    git pull $repoman_dir/redis/.git master:br-redis
    
So far, everything's familiar.    
    
**Step 4**: git subtree merge:

    cd       $homebase_dir
    git subtree merge -P vendor/infochimps/redis br-redis -m "Merge with local mirror of redis cookbook"

This restricts its attention to the files within the vendor/infochimps/redis subdirectory, but is otherwise fairly straightforward.


### To see changes within a subtree ###

Solo-repo changes show up funny in the unified repo. To see them, use

    git log -p -m --first-parent -- vendor/redis

Quoting the git documentation:

> The -m flag makes the merge commits show the full diff like regular commits; for each merge parent, a separate log entry and diff is generated. An exception is that only diff against the first parent is shown when --first-parent option is given; in that case, the output represents the changes the merge brought into the then-current branch.
>
> The --first-parent flag follows only the first parent commit upon seeing a merge commit. This option can give a better overview when viewing the evolution of a particular topic branch, because merges into a topic branch tend to be only about adjusting to updated upstream from time to time, and this option allows you to ignore the individual commits brought in to your history by such a merge.


### Don't Do This ###

Here's something not to do:

    git pull http://github.com/infochimps-cookbooks/redis.git DO NOT DO THIS

This makes git pull in those commits, but *merge them straight into the tree*, with predictably terrible consequences: the redis cookbook's README.md file will be merged with the homebase's README.md file; there will be top-level folders for `recipes/`, `attributes/`, etc. A `git reset --hard` will blow away all the bad changes, plus any other uncommitted changes you had.

__________________________________________________________________________

## Footnotes

* <a name="foot_1"></a> actually, three repo sets: until Opscode does a similar schism we hold the opscode community cookbooks collection as its own homebase)
* <a name="foot_2"></a> If that doesn't mostly make sense, quit reading this and go read [Think Like a Git](http://bit.ly/thinklikeagit) instead


## Bibliography:

Git:
* [Think Like a Git](http://bit.ly/thinklikeagit), strongly recommended
* [Git Subtree](https://github.com/apenwarr/git-subtree), [Git Subtree docs](https://github.com/apenwarr/git-subtree/blob/master/git-subtree.txt)
* [GitX (L)](http://gitx.laullon.com/) (or any other git visualizer)

* [Rake Quick Reference](https://sites.google.com/site/spontaneousderivation/rake-quick-reference)
* [Rake Documentation](http://rubydoc.info/stdlib/rake/frames)

Also: 
* [Github API](http://develop.github.com/p/repo.html)

