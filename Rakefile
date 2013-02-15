#
# Rakefile for Ironfan Pantry
#
# Author::    Nathaniel Eliot
# Copyright:: Copyright (c) 2012 Infochimps, Inc.
# License::   Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'rubygems' unless defined?(Gem)
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake/version_task'
paths = Dir.glob(File.join('cookbooks','*','VERSION'))
cookbooks = paths.map {|path| File.basename(File.split(path)[0]) }
cookbooks.each do |ckbk|
  namespace ckbk do
    Rake::VersionTask.new do |task|
      task.with_git     = true
      task.filename     = File.join('cookbooks',ckbk,'VERSION')
    end
  end
end

namespace :all do
  namespace :version do
    desc "Bump all cookbooks to next patch version"
    task :bump => cookbooks.map {|ckbk| ckbk+':version:bump' }

    namespace :bump do
      desc "Bump all cookbooks to next major version"
      task :major => cookbooks.map {|ckbk| ckbk+':version:bump:major' }

      desc "Bump all cookbooks to next minor version"
      task :minor => cookbooks.map {|ckbk| ckbk+':version:bump:minor' }

      desc "Bump all cookbooks to next prerelease patch version"
      task :pre => cookbooks.map {|ckbk| ckbk+':version:bump:pre' }

      namespace :pre do
        desc "Bump all cookbooks to next prerelease major version"
        task :major => cookbooks.map {|ckbk| ckbk+':version:bump:pre:major' }

        desc "Bump all cookbooks to next prerelease minor version"
        task :minor => cookbooks.map {|ckbk| ckbk+':version:bump:pre:minor' }
      end
    end
  end
end

desc "Install the postcommit hook that ensures VERSION bumps happen"
task :ensure_postcommit_hook do
  hook = <<-eos.gsub(/^ {#{4}}/, '')
    #!/usr/bin/env bash
    #
    # Ensure that all cookbook changes include a bump to the relevant
    #   cookbook's VERSION file.
    #

    echo "Looking for version bumps in changed code"

    timeout 5s git fetch origin

    changes=`git diff --name-only master origin/testing -- cookbooks/*/ | cut -d/ -f2 | sort | uniq`
    if [ "x$changes" = "x" ]; then
      echo "No cookbook changes between master and testing"
      exit 0
    fi

    for cookbook in $changes; do
      if git diff --quiet master origin/testing -- cookbooks/$cookbook/VERSION; then
        echo "INFO: changes found without VERSION, bumping version in $cookbook"
        bundle exec rake $cookbook:version:bump
      fi
    done
  eos
  target = File.join('.git','hooks','post-commit')
  File.open(target,'w') {|f| f.write(hook) }
  File.chmod(0775,target)
end