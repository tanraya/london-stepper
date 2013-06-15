package :deployer do
  description "Deployer: Create user/group and copy SSH keys"
  
  noop do
    # Create: "deployer"-group.
    pre :install, "groupadd #{group}"
    
    # Create: "deployer"-user.
    pre :install, "useradd -m -g #{deployer} #{group}"
    
    # Copy SSH-keys from root.
    pre :install, "mkdir -p /home/#{deployer}/.ssh"
    pre :install, "cp /root/.ssh/id_rsa /home/#{deployer}/.ssh/id_rsa"
    pre :install, "cp /root/.ssh/id_rsa.pub /home/#{deployer}/.ssh/id_rsa.pub"
    pre :install, "cp /root/.ssh/known_hosts /home/#{deployer}/.ssh/known_hosts" # RSA
    
    # Copy authorized_keys from root.
    pre :install, "cp /root/.ssh/authorized_keys /home/#{deployer}/.ssh/authorized_keys" # RSA
    
    # Set proper permissions for deployer's copies.
    pre :install, "chown -R #{deployer}:#{group} /home/#{deployer}/.ssh/"
    pre :install, "chmod 0700 /home/#{deployer}/.ssh"
    pre :install, "chmod 0600 /home/#{deployer}/.ssh/id_rsa"
  end

  verify do
    has_file "/home/#{deployer}/.ssh/id_rsa"
    has_file "/home/#{deployer}/.ssh/id_rsa.pub"
    has_file "/home/#{deployer}/.ssh/authorized_keys" # RSA
  end
end