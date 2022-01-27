# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
OPEN5GS_IPv4_ADDR = "192.168.56.10"
UERANSIM_IPv4_ADDR = "192.168.56.11"
TAC = "2"

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
OPEN5GS_IPv4_ADDR = "192.168.56.10"
UERANSIM_IPv4_ADDR = "192.168.56.11"
TAC = "2"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

# Common configs for both VMs are listed here
config.vm.box = "bento/ubuntu-18.04"
config.vm.box_version = "202112.19.0"
config.vm.box_check_update = false



  # VM #1: OPEN5GS 5G core network (All-in-one)
  config.vm.define "open5gs" do |open5gs|
    open5gs.vm.network "private_network", ip: OPEN5GS_IPv4_ADDR
    # open5gs.vm.network "public_network"

    # forward port for guest tcp/3000 (Open5GS WebUI) to host 3030
    open5gs.vm.network "forwarded_port", guest: 3000, host: 3030 
    
    open5gs.vm.provider "virtualbox" do |vb|
     # Customize the amount of cpu & memory on the VM:
     vb.memory = "4096"
     vb.cpus = "2"
    end

    # Use :ansible or :ansible_local to
    # select the provisioner of your choice
    open5gs.vm.provision :ansible_local do |ansible_local|
        ansible_local.playbook = "ansible-local-provisioners/bootstrap.yaml"
    end

  end

 # VM#2: UERANSIM as our UE & RAN (gNB) Simulator
 config.vm.define "ueransim" do |ueransim|
    ueransim.vm.network "private_network", ip: UERANSIM_IPv4_ADDR

    ueransim.vm.provider "virtualbox" do |vb|
     # Customize the amount of cpu & memory on the VM:
     vb.memory = "2048"
     vb.cpus = "1"
    end

  end

end


