
=begin
set :user, 'vagrant'
set :run_method, :sudo
 
role :app, '192.168.33.10', :primary => true
 
ssh_options[:keys] = `vagrant ssh-config | grep IdentityFile`.split.last.gsub('"', '')
=end

ssh_options[:forward_agent] = true
default_run_options[:pty] = true
ssh_options[:port] = 22

set :use_sudo, false
set :user, 'root'
set :password, 'fuckoff'
set :sudo_prompt, ""
set :runner, nil
set :run_method, :run

role :app, '192.168.1.10', :primary => true
