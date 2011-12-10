#!/usr/bin/env bash

set -e

container=$HOME/ics/schism

origin=infochimps/cluster_chef
gh_url="git@github.com:$origin"

gh_user=`git config --get github.user`
gh_pass=`git config --get github.token`
gh_org=infochimps-cookbooks
gh_api="https://github.com/api/v2/json"

# ===========================================================================
#
# Get Git
#

source=$container/$origin
target=$container/target
result=$container/result
mkdir -p $container $target $result

if [ -d $source ] ; then
  echo "Using existing checkout of $gh_url in $source"
else
  mkdir -p `dirname $source`
  cd       `dirname $source`
  git clone $gh_url
  cd $source
  git checkout version_3
  git checkout -b version_3_schism || git checkout version_3_schism
fi

# ===========================================================================
#
# Git Splitty
#

cd $source
for foo in site-cookbooks/* meta-cookbooks/* ; do
  repo=`basename $foo`

  echo
  echo -e "================================="
  echo -e "==\n== Processing $repo\n==\n"

  # # this is how I can just kill a repo. kablau.
  # tok=$(curl -X POST -F "login=$gh_user" -F "token=$gh_pass" "$gh_api/repos/delete/$gh_org/$repo" | ruby -ne '$_ =~ /:"(.*)"/; puts $1') ; echo $tok ; curl -X POST -F "login=$gh_user" -F "token=$gh_pass"  -F "delete_token=$tok" "$gh_api/repos/delete/$gh_org/$repo"

  echo -e "\n==\n== creating bare repo $target/$repo.git\n==\n"
  mkdir -p $target/$repo.git
  cd       $target/$repo.git
  if   [ -f $target/$repo.git/HEAD ] ;
  then echo "repo exists, not initializing" ;
  else git init --bare
  fi
  
  echo -e "\n==\n== splitting git history into $repo branch in $source\n==\n"
  cd $source
  git-subtree split -P $foo --annotate='s: ' -b $repo --rejoin
  
  echo -e "\n==\n== pushing into $target/$repo.git\n==\n"
  git push $target/$repo.git $repo:master
  
  echo -e "\n==\n== checking out new repo into $result/$repo\n==\n"
  cd $result
  git clone $target/$repo.git || true
  
  # ===========================================================================
  #
  # Github repo creation
  #
  
  echo -e "\n==\n== Creating git@github.com:$gh_org/$repo\n==\n"
  
  curl -X POST -F "login=$gh_user" -F "token=$gh_pass"                                         \
    -F "name=$gh_org/$repo"                                                                    \
    -F "public=1"                                                                              \
    https://github.com/api/v2/json/repos/create
  
  echo -e "\n==\n== Setting properties on git@github.com:$gh_org/$repo\n==\n"
  
  curl -X POST -F "login=$gh_user" -F "token=$gh_pass"                                         \
    -F "name=$gh_org/$repo"                                                                    \
    -F "values[homepage]=http://github.com/infochimps-labs/cluster_chef_homebase"              \
    -F "values[has_wiki]=0"                                                                    \
    -F "values[has_issues]=0"                                                                  \
    -F "values[has_downloads]=1"                                                               \
    -F "values[description]=$repo chef cookbook - automatically installs and configures $repo" \
    https://github.com/api/v2/json/repos/show/$gh_org/$repo
  echo

  echo -e "\n==\n== Pushing to git@github.com:$gh_org/$repo\n==\n"
  cd $result/$repo
  git remote add "$gh_org" "git@github.com:$gh_org/$repo" || true
  git push -u "$gh_org"

done

echo
echo "Done!"
