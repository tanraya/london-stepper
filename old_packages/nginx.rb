package :nginx, :provides => :webserver do
  describe "Nginx web server"
  apt "nginx" do
    post :install, '/etc/init.d/nginx start'
  end

  verify do
    has_process 'nginx'
  end
end