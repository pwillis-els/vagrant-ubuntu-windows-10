# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # https://docs.vagrantup.com.

  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "bento/ubuntu-20.04"

  # config.vm.box_check_update = false

  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  # config.vm.network "private_network", ip: "192.168.33.10"
  # config.vm.network "public_network"

  # Uncomment this and set your adapter index to create a static private interface
  #config.vm.network "private_network", ip: "192.168.88.10", :adapter => 2

  config.ssh.forward_x11 = true

  # This is superfluous, as "/vagrant" is already shared to your Vagrantfile dir
  #config.vm.synced_folder "./data", "/vagrant_data"
  #config.vm.synced_folder "c:\\Users\\willis\\OneDrive", "/onedrive"

  config.vm.provider "virtualbox" do |vb|
     # Customize the amount of memory on the VM:
     vb.memory = "4096"
     vb.cpus = 2
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
   config.vm.provision "shell", inline: <<-SHELL
     export DEBIAN_FRONTEND=noninteractive

     apt-get update -y
     apt-get install -y apt-transport-https ca-certificates curl software-properties-common

     # Install Docker
     curl -fsSL https://download.docker.com/linux/"${release_name}"/gpg | apt-key add -
     apt-key fingerprint 0EBFCD88
     add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
     apt-get update
     apt-get install -y "docker-ce"
     unset http_proxy https_proxy no_proxy
     usermod -a -G docker vagrant || true
     docker info

     # Apt-get upgrade is disabled here because it'll hang the provisioner trying to ask questions.
     #apt-get upgrade -y
     apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

     apt-get install -y python3 python3-pip python3-wheel python3-virtualenv

     # Install a graphical terminal for X11 forwarding
     apt-get install -y xauth rxvt x11-xserver-utils

     # If you need to modify your DNS servers, you may need the following configuration:
     # 1. Create this file
     #      # /etc/systemd/resolved.conf
     #      [Resolve]
     #      DNS=10.90.163.133 10.90.131.133 8.8.8.8 1.1.1.1
     # 
     # 2. Copy /lib/systemd/system/docker.service to /etc/systemd/system/
     # 3. Add '--dns <ip1> --dns <ip2> ...' to /etc/systemd/system/docker.service
     # 4. Run 'systemctl daemon-reload ; systemctl restart docker ; systemctl enable docker
     # 5. Enable tcp mode in docker daemon
     
     # Install miscellaneous useful tools
     apt-get install -y bash-completion ldap-utils sendmail bsd-mailx

     # Set timezone
     #sudo timedatectl set-timezone US/Eastern
   SHELL
end
