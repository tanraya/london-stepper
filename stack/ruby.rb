package :ruby, :provides => :ruby do
  description "Ruby 1.9.2 (RVM)"
  requires :ruby_dependencies, :rvm, :rvm_ruby_19, :bundler
end

package :ruby_dependencies do
  apt 'build-essential bison openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev autoconf'
end

package :rvm do
  description "RVM - Ruby Version Manager"
  
  apt 'ruby-full' do
    # Install RVM.
    post :install, 'bash < <( curl -L https://github.com/wayneeseguin/rvm/raw/master/contrib/install-system-wide )'
    post :install, 'rvm reload'
    
    # Add deployer to rvm group (root added already by RVM installer).
    post :install, %Q{adduser #{deployer} rvm}
    
    # Update Rubygems (non-verbose).
    post :install, 'gem update --system > /dev/null 2>&1'
    
    # Save RVM status (for verification).
    post :install, 'type rvm | head -n1 > /tmp/.rvm_status'
  end
  
  bashrc_replace_text = {
    '[ -z "$PS1" ] && return' => 'if [[ -n "$PS1" ]]; then'
  }
  bashrc_append_text = 'fi'
  source_rvm_script = File.read(File.join(File.dirname(__FILE__), 'ruby', 'source_rvm.sh'))
  
  # Patch .basrc to load RVM properly.
  replace_text replace_text.keys.first, replace_text.values.first, "/home/#{deployer}/.bashrc"
  push_text bashrc_append_text, "/home/#{deployer}/.bashrc"
  
  # Source RVM - automatically load RVM (should work for most shells; bash, zsh, ...).
  push_text source_rvm_script, "/etc/skel/#{deployer}/.profile" do
    # Ensure file/path exists.
    pre :install, 'mkdir /etc/skel && touch /etc/skel/.profile'
    
    # Create: /root/.profile
    post :install, "cp /etc/skel/.profile /root/.profile"

    # Create: /home/deployer/.profile
    post :install, "cp /etc/skel/.profile /home/#{deployer}/.profile"
    post :install, "chown #{deployer}:#{group} /home/#{deployer}/.profile"
  end
  
  verify do
    # Ensure RVM binary was setup properly: should be a function, not a executable.
    file_contains '/tmp/.rvm_status', "rvm is a function"
    
    # Ensure ~/.bashrc was patched to work with RVM.
    file_contains "/home/#{deployer}/.bashrc", bashrc_replace_text.values.first
    file_contains "/home/#{deployer}/.bashrc", bashrc_append_text
    
    # Ensure RVM is sourced in ~/.profile.
    ['/etc/skel', '/root', "/home/#{deployer}"].each do |path|
      has_file "#{path}/.profile"
      file_contains "#{path}/.profile", source_rvm_script
    end
  end
end

package :rvm_ruby_19 do
  description "Ruby 1.9.2"
  version     '1.9.2'
  requires    :rvm
  
  noop do
    # Install Ruby 1.9.
    pre :install, 'rvm install 1.9.2'
  end
end

package :bundler do
  description "Bundler - Ruby dependency manager"
  requires    :rvm
  
  gem 'bundler'
  
  verify do
    has_executable 'bundle'
  end
end
