package :mysql do
  describe 'MySQL Client and Server'
  apt 'mysql-server mysql-client libmysql-ruby libmysqlclient-dev' do
    #post :install, ""
  end

  verify do
    has_executable 'mysqld'
    has_executable 'mysql'
    has_process    'mysqld'
  end
end