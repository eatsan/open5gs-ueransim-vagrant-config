# Vagrant configuration for Open5GS & UERANSIM setup
This repository provides a simple Vagrantfile and the required provisioning shell scripts for creating an Open5GS 5GC &amp; UERANSIM UE/gNB setup with 2 VirtualBox VMs that is pre-configured with quickstart documentation defaults.


# Overview
- Open5GS is an open-source implementation of 5G Core and Evolved Packet Core (EPC).  Open5GS's source code can be accessed [here](https://github.com/open5gs/open5gs).
- UERANSIM is an open-source  5G UE and RAN (gNodeB) implementation. It can be considered as a 5G user equipment and a base station emulation.  You can access its source code [here](https://github.com/aligungr/UERANSIM).

Using the Vagrantfile provided in this repository, you can create two seperate VirtualBox VMs (one for Open5GS and another one UERANSIM) that will be connected to each other over a VirtualBox host-only private network (CIDR *192.168.33.0/24*). Besides the creation of the required VMs, vagrant will also provision each VM with the required configuration changes described in the [Open5GS](https://open5gs.org/open5gs/docs/guide/01-quickstart/) &amp; [UERANSIM](https://github.com/aligungr/UERANSIM/wiki/Configuration) documentation. Once your VMs are created & booted after the `vagrant up`, you will have a ready UERANSIM gNB running in the ueransim VM already connected to the Open5GS AMF. 

## Why should I use this repository?
This repository targets for users who have already followed the Open5GS &amp; UERANSIM tutorials before and would like to **have a quick working Open5GS 5GC setup with UERANSIM gNB/UE**. Consider this as a development environment that can be easily reverted back to a preconfigured state with minimal manual configuration effort from your side. 

## Why Vagrant?
Vagrant provides a simple command line tool for managing the lifecycle of virtual machines via `Vagrantfiles`. Vagrantfiles describe the type of machines required for a project, and how to configure and provision these machines in an automated and reproducible way. 
The syntax of Vagrantfiles is Ruby and Vagrantfiles are portable across every platform that Vagrant supports. However, the configuration provided in this repo is tested only on Ubuntu Bionic (18.04 LTS) amd64. 

Vagrant ships out of the box with support for VirtualBox, Hyper-V, and Docker as virtualisation provider. A VMware provider plugin for VMware Fusion & Workstation is also available. See [here](https://www.vagrantup.com/docs/providers) for more details on the Vagrant providers. 

In this repository, we will use the [VirtualBox](https://www.virtualbox.org/) since it is one of the most popular cross-platform type 2 hypervisor in the market. 

More on why vagrant is a great tool can be read [here](https://www.vagrantup.com/intro#why-vagrant).

# Prerequisites  
- VirtualBox 6.0+ (https://www.virtualbox.org/)
- Hashicorp Vagrant 2.2.7+ (https://www.vagrantup.com/)
- Ubuntu server Bionic / 18.04 LTS

> Other operating systems that Virtualbox + Vagrant support is likely to work (in principle). However, it has never been tested. 

# Installation
You can skip Step 1 if you already have a Vagrant / VirtualBox installed that satisfies the prerequisites. 
## Step 1: Install prerequisites

### Ubuntu

Install Vagrant
```bash
wget https://releases.hashicorp.com/vagrant/2.2.19/vagrant_2.2.19_x86_64.deb
sudo apt install ./vagrant_2.2.19_x86_64.deb

# Verify installation
vagrant --version
```
Install VirtualBox
```bash
# Add Oracle public key for apt-secure
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -

# Add virtualbox to your apt sources list
echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

sudo apt-get update
sudo apt-get install virtualbox-6.1

# Verify installation
vboxmanage --version
```

### macOs
TODO


## Step 2: Deploy via `vagrant up`
TODO
## Verify vagrant installation
TODO
# Attach UE 
TODO

# Optional: Vagrantfile walkthrough 
TODO

