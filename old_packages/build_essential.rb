package :build_essential do
  description 'Build tools'

  apt 'build-essential' do
    pre :install, 'apt-get update'
  end

  apt 'bash' do
    # Make sure we are running a Bash shell
    post :install, 'ln -sf /bin/bash /bin/sh'
  end

  verify do
    has_executable 'gcc'
    has_executable 'g++'
    has_executable '/bin/bash'
    has_symlink    '/bin/sh', '/bin/bash'
    has_apt        'build-essential'
  end
end