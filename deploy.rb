ssh_options[:forward_agent] = true
default_run_options[:pty] = true
ssh_options[:port] = 22

set :use_sudo, false
set :user, 'root'
set :password, 'fuckoff'
set :sudo_prompt, ""
set :runner, nil
set :run_method, :run

role :app, '46.21.100.241', :primary => true

