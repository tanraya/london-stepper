package :nginx, :provides => :webserver do
  describe "Nginx web server"
  requires :nginx_dependencies

  apt "nginx" do
    post :install, '/etc/init.d/nginx start'
    post :install, "chown -R #{deployer}:#{group} /var/log/nginx" # Does we need that?
  end

  verify do
    has_process 'nginx'
  end
end

package :nginx_dependencies do
  apt 'libcurl4-openssl-dev'
end