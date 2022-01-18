# Vagrant configuration for Open5GS & UERANSIM setup
This repository provides a single Vagrant configuration and the required provisioning shell scripts for creation a Open5GS 5GC &amp; UERANSIM UE/gNB setup with 2 VirtualBox VMs.



# Overview
- Open5GS is an open-source implementation of 5G Core and Evolved Packet Core (EPC).  Open5GS's source code can be accessed [here](https://github.com/open5gs/open5gs).
- UERANSIM is an open-source  5G UE and RAN (gNodeB) implementation. It can be considered as a 5G user equipment and a base station simulation in simple terms.  You can access the source code [here](https://github.com/aligungr/UERANSIM).

Using the Vagrantfile provided in this repository, you can create two seperate VirtualBox VMs (one for Open5GS and another one UERANSIM) that will be connected to each other over a VirtualBox host-only private network (192.168.33.0/24). Besides the creation of the required VMs, vagrant will provision each VM with the required configuration changes described in the [Open5GS](https://open5gs.org/open5gs/docs/guide/01-quickstart/) &amp; [UERANSIM](https://github.com/aligungr/UERANSIM/wiki/Configuration) documentation. Once your VMs are created & booted after the `vagrant up`, you will have a ready UERANSIM gNB running in the ueransim VM already connected to the Open5GS AMF. 

## Who should use this repository?
This repository targets for users who have already followed the Open5GS &amp; UERANSIM tutorials before and would like to **quickly have a working basic Open5GS 5GC with UERANSIM gNB setup**. 

## Why Vagrant?
Vagrant provides a simple command line tool for managing the lifecycle of virtual machines via `Vagrantfiles`. Vagrantfiles describe the type of machines required for a project, and how to configure and provision these machines in an automated and reproducible way. 
The syntax of Vagrantfiles is Ruby and Vagrantfiles are portable across every platform that Vagrant supports. However, the configuration provided in this repo is tested only with Ubuntu Bionic (18.04) amd64. 

Vagrant ships out of the box with support for VirtualBox, Hyper-V, and Docker. Hashicorp also provides a Vmware provider plugin for Vmware Fusion & Workstation. See [here](https://www.vagrantup.com/docs/providers) for more details on the Vagrant providers. In this repository, we will use the [VirtualBox](https://www.virtualbox.org/) provider since it is one of the most popular cross-platform type 2 hypervisor in the market. 

# Prerequisites  
TODO
# Installation
TODO
## Step 1: Install required software
TODO
## Step 2: Deploy via `vagrant up`
TODO
## Verify vagrant installation
TODO
# Attach UE 
TODO

# Optional: Vagrantfile walkthrough 
TODO

