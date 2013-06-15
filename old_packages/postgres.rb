package :postgres, :provides => :database do
  description 'PostgreSQL database'
  requires :postgres_core, :postgres_user, :postgres_database#, :postgres_autostart
end

package :postgres_core do
  apt %w( postgresql postgresql-client libpq-dev )
  
  verify do
    has_executable 'psql'
    has_apt 'postgresql'
    has_apt 'postgresql-client'
    has_apt 'libpq-dev'
  end
end
  
package :postgres_user do
  runner %{echo "CREATE ROLE estrabota WITH LOGIN ENCRYPTED PASSWORD 'hYsbTbfoq3';" | sudo -u postgres psql}
  
  verify do
    @commands << "echo 'SELECT ROLNAME FROM PG_ROLES' | sudo -u postgres psql | grep estrabota"
  end
end

package :postgres_database do
  runner "sudo -u postgres createdb --owner=estrabota estrabota_production"
  
  verify do
    @commands << "sudo -u postgres psql -l | grep estrabota_production"
  end  
end
=begin
package :postgres_autostart do
  description "PostgreSQL: Autostart on reboot"
  requires :postgres_core
  
  runner '/usr/sbin/update-rc.d postgresql-9.2 defaults'
end

%w[start stop restart reload].each do |command|
  package :"postgres_#{command}" do
    requires :postgres_core

    runner "/etc/init.d/postgresql-9.2 #{command}"
  end
end
=end