package :ruby do
  description 'Ruby Language'
  version '1.9.3'
  source "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p125.tar.gz"
  requires :ruby_dependencies
  
  verify do
    has_executable "ruby"
  end
end

package :ruby_dependencies do
  apt 'build-essential bison openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev autoconf'
end

package :bundler do
  description "Bundler - Ruby dependency manager"

  gem 'bundler'
  
  verify do
    has_executable 'bundle'
  end
end
