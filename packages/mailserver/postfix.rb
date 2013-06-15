package :postfix, :provides => :mailserver do
  description "Postfix - mail server"
  
  requires :postfix_core, :postfix_config, :postfix_autostart, :postfix_restart
end

package :postfix_core do
  apt 'postfix' do
    
  end

  verify do
    has_executable 'postfix'
    has_file '/etc/init.d/postfix'
  end
end

package :postfix_config do
  description "Postfix: Config"
  requires :postfix_core
  
  %w[main master].each do |config_name|
    config_file = "/etc/postfix/#{config_name}.cf"
    config_template = File.join(File.dirname(__FILE__), 'postfix', "#{config_name}.cf")

    transfer config_template, config_file, :render => true do
      # Ensure path exists.
      pre :install, "mkdir -p #{File.dirname(config_file)}"
      
      # Set proper permissions.
      post :install, "chmod 0644 #{config_file}"
    end
    
    verify do
      has_file config_file
    end
  end
end

package :postfix_autostart do
  description "Postfix: Autostart on reboot"
  requires :postfix_core
  
  noop do
    pre :install, '/usr/sbin/update-rc.d postfix default'
  end
  
  verify do
  end
end

%w[start stop restart reload].each do |command|
  package :"postfix_#{command}" do
    requires :postfix_core

    noop do
      pre :install, "/etc/init.d/postfix #{command}"
    end
  end
end

