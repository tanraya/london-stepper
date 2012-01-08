#!/usr/bin/env sprinkle -s
require 'rubygems'
require 'bundler/setup'

# Usage:
#
# $ bundle
#
# $ sprinkle -s london-stepper.rb
#
# or in test mode:
#
# $ sprinkle -t -s london-stepper.rb

require File.dirname(__FILE__) + '/packages/build_essential'
require File.dirname(__FILE__) + '/packages/curl'
require File.dirname(__FILE__) + '/packages/git'
require File.dirname(__FILE__) + '/packages/htop'
require File.dirname(__FILE__) + '/packages/rsync'
require File.dirname(__FILE__) + '/packages/imagemagick'
require File.dirname(__FILE__) + '/packages/ruby'
require File.dirname(__FILE__) + '/packages/mysql'
require File.dirname(__FILE__) + '/packages/sphinx'
require File.dirname(__FILE__) + '/packages/nginx'
require File.dirname(__FILE__) + '/packages/memcached'
require File.dirname(__FILE__) + '/packages/monit'

policy :stack, :roles => :app do
  requires :build_essential
  requires :curl
  requires :git
  requires :htop
  requires :rsync
  requires :imagemagick  
  requires :ruby
  requires :mysql
  requires :sphinx
  requires :nginx
  requires :memcached
  requires :monit
end

deployment do

  # mechanism for deployment
  delivery :capistrano do
    recipes 'deploy'
  end

  # source based package installer defaults
  source do
    prefix   '/usr/local'
    archives '/usr/local/sources'
    builds   '/usr/local/build'
  end

end