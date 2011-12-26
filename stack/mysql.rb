package :mysql, :provides => :database do
  describe 'MySQL Client and Server'
  apt 'mysql-server mysql-client libmysqlclient16-dev libmysql-ruby libmysqlclient-dev' do
    post :install, ""
  end

  verify do
    has_executable 'mysqld'
    has_executable 'mysql'
    has_process    'mysqld'
  end

  optional :mysql_ruby_driver
end

package :mysql_ruby_driver do
  requires :rubygems
  description 'Ruby MySQL Library'
  gem 'mysql2'

  verify do
    has_gem 'mysql2'
    ruby_can_load 'mysql2'
  end
end