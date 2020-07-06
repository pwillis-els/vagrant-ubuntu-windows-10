# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # https://docs.vagrantup.com.

  # boxes at https://vagrantcloud.com/search.
  # neither 19.04 or 20.04 worked for me, only 18.04 did
  # as of 07/05/2020
  config.vm.box = "bento/ubuntu-18.04"
  config.vm.box_version = "202005.21.0"

  config.vm.boot_timeout = 5000
  config.vm.hostname = "devbox"
  config.vm.define "devbox"

  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  # config.vm.network "private_network", ip: "192.168.33.10"
  # config.vm.network "public_network"

  # Uncomment this and set your adapter index to create a static private interface
  #config.vm.network "private_network", ip: "192.168.88.10", :adapter => 1
  #config.vm.network "private_network", ip: "192.168.88.10"

  # this *may* work as a default network.
  # you may want to set up a default NAT device in VirtualBox first.
  config.vm.network "private_network", type: "dhcp"

  # Install VcXsrv X Windows server on Windows, and this option will
  # allow graphical apps in your VM to appear in Windows
  config.ssh.forward_x11 = true

  #config.vm.synced_folder "./data", "/vagrant_data"
  #config.vm.synced_folder "c:\\Users\\willis\\OneDrive", "/onedrive"

  # Configure the VirtualBox provider
  config.vm.provider "virtualbox" do |vb|

     # The VirtualBox name of this VM
     vb.name = "devbox"

     # Customize the amount of memory and CPU on the VM
     vb.memory = "4096"
     vb.cpus = 2

  end

  # If you use 'vagrant up --provider=hyperv', and you have correctly
  # set up HyperV in Windows 10, and VirtualBox is not installed at all,
  # it is possible to use HyperV to run your VMs. But HyperV does not yet
  # support things like synced folders, and you will have to manually
  # select a single network to connect. So VirtualBox is still much more
  # practical.
  # 
  #config.vm.provider "hyper-v" do |hv|
  #end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # 
  config.vm.provision "shell", path: "provision.sh"

end
