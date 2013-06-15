#!/usr/bin/env sprinkle -s
# https://github.com/grimen/sprinkle-stack
require 'rubygems'
require 'bundler/setup'
require File.expand_path("../base.rb", __FILE__)

# Require all packages.
#Dir[File.join('packages', '**', '*.rb')].each do |package|
  #puts %Q{require File.expand_path("../#{package}", __FILE__)}
  #require File.expand_path("../#{package}", __FILE__)
#end

require File.expand_path("../packages/mailserver/postfix.rb", __FILE__)
require File.expand_path("../packages/redis/redis.rb", __FILE__)
#require File.expand_path("../packages/process_monitoring/monit.rb", __FILE__)
#require File.expand_path("../packages/system/deployer.rb", __FILE__)
require File.expand_path("../packages/system/tools.rb", __FILE__)
#require File.expand_path("../packages/system/logrotate.rb", __FILE__)
require File.expand_path("../packages/scm/git.rb", __FILE__)
require File.expand_path("../packages/sphinxsearch/sphinxsearch.rb", __FILE__)
require File.expand_path("../packages/webserver/nginx.rb", __FILE__)
require File.expand_path("../packages/database/postgresql.rb", __FILE__)
require File.expand_path("../packages/lang/ruby.rb", __FILE__)

# Stack setup.
policy :stack, :roles => :app do
  requires :tools                   # Common system tools and dependencies
  requires :redis
  requires :scm                     # Git
  requires :ruby                    # RVM: REE + 1.9.2 + Bundler
  requires :webserver               # Nginx
  #requires :mailserver              # Postfix
  requires :database                # MySQL or Postgres, also installs rubygems for each
  #requires :process_monitoring      # Monit
  requires :sphinxsearch
  #requires :logrotate
  #requires :cleanup
end

# Usage:
#
# $ bundle
#
# $ sprinkle -s london-stepper.rb
#
# or in test mode:
#
# $ sprinkle -t -s london-stepper.rb

=begin
  TODO

  0. Создание инфраструктуры стандартного сервера
    1.1. Установка всех зависимостей

  1. Создание инфраструктуры сервера RocketScience (зависит от п. 0)
    1.1. Установка Geminabox
    1.2. Развертывание gitolite
    1.3. Развертывание gitlab
    1.4. Создание юзеров с ключами (oleg, tanraya)
  2. Создание на сервере инфраструктуры под проект
    2.1. Структура директорий проекта Rails
    2.2. Структура директорий статического проекта
    2.3. Пользователь БД и сама база

  Гем rocsci создаёт Rails приложение.
  Гем rocsci_deployment устанавливает в указанном приложении capistrano и создаёт его конфиг,
  настроенный на п.1, а так же создаёт конфигурацию для nginx. Кроме того, устанавливает и конфигурит
  whenever.

  Кроме всего, и самое главное, гем rocsci_deployment создаёт инфраструктуру под проект на удаленном
  сервере.

  Цель: развертывание сервера и проекта в автоматическом режиме за короткое время.

  Шаги:

  * Развертываем сервер RocketScience
  * Создаём проект на локальной машине при помощи rocsci
  * Добавляем в проект тулзы для деплоя при помощи rocsci_deployment (это также создаёт инфраструктуру
    под проект на удаленном сервере)
  * Деплоим проект на сервер
=end

# Full rails stack with MySql
=begin
policy :stack_with_mysql, :roles => :app do
  requires :build_essential
  requires :curl
  requires :git
  requires :htop
  requires :rsync
  requires :imagemagick
  requires :libmagick_dev
  requires :ruby
  requires :sphinx
  requires :nginx
  requires :monit
  requires :mysql
end


# Full rails stack with Postgres
policy :stack_with_postgres, :roles => :app do
  requires :build_essential
  requires :curl
  requires :git
  requires :htop
  requires :rsync
  requires :imagemagick  
  requires :ruby
  #requires :sphinx
  requires :nginx
  requires :redis
  requires :monit
  requires :mailserver
  #requires :postgres
end

=end
deployment do
  # mechanism for deployment
  delivery :capistrano do
    recipes 'deploy'

    set :deployer, 'estrabota'
    set :group,    'estrabota'
    set :user,     'root'
  end

  # source based package installer defaults
  source do
    prefix   '/usr/local'
    archives '/usr/local/sources'
    builds   '/usr/local/build'
  end
end

=begin

# Deployment procedure - and preferences.
deployment do
  # Mechanism for deployment.
  delivery :capistrano do
    begin
      recipes 'Capfile'
    rescue LoadError
      begin
        recipes 'deploy'
      rescue LoadError
      end
    end

    ssh_options[:forward_agent] = true
    default_run_options[:pty] = true
    
    vars = {
      :app      => {:label => ":app, host domain/IP",     :default => nil},
      :deployer => {:label => ":deployer, deploy-user",   :default => 'estrabota'},
      :user     => {:label => ":root, setup-user",        :default => 'root'},
      :group    => {:label => ":group, deployers-group",  :default => 'estrabota'}
    }
    
    # Ensure defined - if not, then ask.
    vars.keys.each do |var|
      unless vars[var].present?
        print "#{vars[var][:label]} (default: #{vars[var][:default]}): "
        value = gets || vars[var][:label]
        set var, value
      end
    end
    
    if vars[:app].blank?
      puts "[stack/setup.rb] No valid host specified for role :app. Needs to be a valid domain or IP. Specified: #{app.inspect}"
      exit
    end
  end

  # Source based package installer defaults.
  source do
    prefix   '/usr/local'
    archives '/usr/local/sources'
    builds   '/usr/local/build'
  end
end
=end