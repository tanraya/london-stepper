package :mysql, :provides => :database do
  describe 'MySQL Client and Server'
  requires :mysql_core, :mysql_config, :mysql_root_password
end

package :mysql_core do
  apt 'mysql-server mysql-client libmysql-ruby libmysqlclient-dev' do
    post :install, "chown -R #{deployer}:#{group} /var/log/mysql"
  end

  verify do
    has_executable 'mysqld'
    has_executable 'mysql'
    has_process    'mysqld'
    has_file       '/etc/init.d/mysql'
    has_file       '/etc/logrotate.d/mysql'
  end
end

package :mysql, :provides => :database do
  description 'MySQL Database'

  requires :mysql_core, :mysql_config, :mysql_roles, :mysql_root_password, :mysql_restart
end

package :mysql_root_password do
  description "MySQL: Set database root password"
  requires :mysql_core
  
  db_password = nil unless defined?(db_password)
  
  print "Enter a new MySQL root password (default: #{db_password}): "
  db_password = gets || ''

  runner %{mysqladmin -u root password #{db_password}}
  
  verify do
    # TODO: Test if password was set correctly.
  end
end

package :mysql_config do
  description "MySQL: Config"
  requires :mysql_core
  
  %w(my.conf).each do |config_file|
    config_file = "/etc/mysql/#{config_file}"
    config_template = File.join(File.dirname(__FILE__), 'mysql', "#{config_file}")
    
    transfer config_template, config_file, :render => true do
      pre :install, "mkdir -p #{File.dirname(config_file)} && test -f #{config_file} && rm #{config_file}"
    end
    
    verify do
      has_file config_file
      file_contains config_file, `head -n 1 #{config_template}`
    end
  end
end