package :postgresql, :provides => :database do
  description "PostgreSQL database"
  
  requires :postgresql_core, :postgresql_config, :postgresql_root_password
end

package :postgresql_core do
  version '8.4'
  
  apt 'postgresql postgresql-client libpq-dev' do
    post :install, "chown -R #{deployer}:#{group} /var/log/postgresql"
    #post :install, 'ln -sf /etc/init.d/postgresql-8.4 /etc/init.d/postgresql'
  end
  
  verify do
    has_executable 'psql'
    
    #has_file '/etc/init.d/postgresql'
    #has_file '/etc/logrotate.d/postgresql-common'
    
    #has_symlink '/etc/init.d/postgresql', '/etc/init.d/postgresql-8.4'
  end
end

package :postgresql_root_password do
  description "PostgreSQL: Set database root password"
  requires :postgresql_core
  
  db_password = nil unless defined?(db_password)
  
  puts "Enter a new PostgreSQL root password (default: #{db_password}): "
  db_password = gets || ''
  
  noop do
    pre :install,
      %{psql -U postgres template1 -c "ALTER USER #{deployer} with encrypted password '#{db_password}';"}
  end
  
  verify do
    # TODO: Test if password was set correctly.
  end
end

package :postgresql_config do
  description "PostgreSQL: Config"
  requires :postgresql_core
  
  %w(postgresql.conf pg_hba.conf).each do |config_file|
    config_file = "/etc/postgresql/8.4/main/#{config_file}"
    config_template = File.join(File.dirname(__FILE__), 'postgresql', "#{config_file}")
    
    transfer config_template, config_file, :render => true do
      pre :install, "mkdir -p #{File.dirname(config_file)} && test -f #{config_file} && rm #{config_file}"
    end
    
    verify do
      has_file config_file
      #file_contains config_file, `head -n 1 #{config_template}`
    end
  end
end