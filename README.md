# Vagrant configuration for Open5GS & UERANSIM setup
This repository provides a simple Vagrantfile and the required provisioning shell scripts for creating an Open5GS 5GC &amp; UERANSIM UE/gNB setup with 2 VirtualBox VMs that is pre-configured with quickstart documentation defaults (only for 5GC elements, i.e. AMF, UPF).


# Overview
- Open5GS is an open-source implementation of 5G Core and Evolved Packet Core (EPC).  Open5GS's source code can be accessed [here](https://github.com/open5gs/open5gs).
- UERANSIM is an open-source  5G UE and RAN (gNodeB) implementation. It can be considered as a 5G user equipment and a base station emulation.  You can access its source code [here](https://github.com/aligungr/UERANSIM).

Using the Vagrantfile provided in this repository, you can create two seperate VirtualBox VMs (one for Open5GS and another one UERANSIM) that will be connected to each other over a VirtualBox host-only private network (default CIDR *192.168.56.0/21*). Besides the creation of the required VMs, vagrant will also provision each VM with the required configuration changes described in the [Open5GS](https://open5gs.org/open5gs/docs/guide/01-quickstart/) &amp; [UERANSIM](https://github.com/aligungr/UERANSIM/wiki/Configuration) documentation. Once your VMs are created & booted after the `vagrant up`, you will have a ready UERANSIM gNB running in the ueransim VM already connected to the Open5GS AMF. 

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

> Other operating systems with Virtualbox & Vagrant support is likely to work (in principle). However, it has never been tested. There is a TODO for testing with macOS. 

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


## Step 2: Install & start VMs
Clone this repository
```bash
git clone https://github.com/eatsan/open5gs-ueransim-vagrant-config.git
```

Deploy vagrant machines configured in the `Vagrantfile`
```bash
cd open5gs-ueransim-vagrant-config/

# Vagrant will download the necessary vagrant box if it is not present in your system
vagrant up
```

Depending on your hardware and internet connectivity, vagrant will bring the VMs up in around 10 minutes. 
Once the vagrant up command completes, you should be able to see the vagrant machines' status as follows: 

```bash
$ vagrant status
Current machine states:

open5gs                   running (virtualbox)
ueransim                  running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

## Verify vagrant installation
Assuming that both vagrant machines are in the `running` state after the vagrant status check, we can ssh to both machines via: 
```bash
vagrant ssh open5gs
vagrant ssh ueransim
```
### Open5gs machine
Let's ssh to the open5gs machine via above command and check the status of the AMF/UPF running: 
```bash
sudo systemctl status open5gs-amfd
sudo systemctl status open5gs-upfd
```

Ensure that both systemd services are in `active (running)` state. 

Finally, let's check if the iptables NAT entries are deployed in the POSTROUTING chain  of the machine: 

```bash
$ sudo iptables -L -t nat --verbose
Chain PREROUTING (policy ACCEPT 4 packets, 324 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain INPUT (policy ACCEPT 3 packets, 240 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 27 packets, 2041 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain POSTROUTING (policy ACCEPT 27 packets, 2041 bytes)
 pkts bytes target     prot opt in     out     source               destination
    1    84 MASQUERADE  all  --  any    !ogstun  10.45.0.0/16         anywhere
```
### UERANSIM machine

```
vagrant ssh ueransim
```
Similarly, after ssh-ing to the ueransim machine, we can check the status of gNB process to validate the successful deployment: 

```bash
sudo screen -r ueransim-gnb
```

This will take you to the terminal where you should see the log `NG Setup procedure is successful`: 

```bash
UERANSIM v3.2.6
[2022-01-24 13:35:57.654] [sctp] [info] Trying to establish SCTP connection... (192.168.56.10:38412)
[2022-01-24 13:35:57.657] [sctp] [info] SCTP connection established (192.168.56.10:38412)
[2022-01-24 13:35:57.657] [sctp] [debug] SCTP association setup ascId[2]
[2022-01-24 13:35:57.657] [ngap] [debug] Sending NG Setup Request
[2022-01-24 13:35:57.658] [ngap] [debug] NG Setup Response received
[2022-01-24 13:35:57.658] [ngap] [info] NG Setup procedure is successful
```
You can detach from this screen session via `CTRL+A D` (CTRL+A and then D). 

> Make sure that you detach from the session using the command above instead of killing it via CTRL+C. 
# Attach UE 
Final step of connecting a UERANSIM UE to the OPEN5GS core is left to the reader. Once you ssh-ed to the ueransim machine via vagrant, you can run the command below that will attach a UE to the core network and create a tun tunnel for testing connectivity. 
```bash
sudo screen -dmS ueransim-ue /home/vagrant/UERANSIM/build/nr-ue -c /home/vagrant/UERANSIM/config/open5gs-ue.yaml
``` 
 At this point `sudo screen -list` should return 2 screen sessions as follows:

 ```bash
 sudo screen -list
There are screens on:
	1810.ueransim-ue	(01/24/2022 02:06:55 PM)	(Detached)
	1671.ueransim-gnb	(01/24/2022 01:35:57 PM)	(Detached)
2 Sockets in /run/screen/S-root.
 ```

 You can check the UE's internet connectivity via :

 ```bash
$ ping -I uesimtun0 9.9.9.9 -c 5
PING 9.9.9.9 (9.9.9.9) from 10.45.0.3 uesimtun0: 56(84) bytes of data.
64 bytes from 9.9.9.9: icmp_seq=1 ttl=61 time=4.69 ms
64 bytes from 9.9.9.9: icmp_seq=2 ttl=61 time=4.13 ms
64 bytes from 9.9.9.9: icmp_seq=3 ttl=61 time=4.23 ms
64 bytes from 9.9.9.9: icmp_seq=4 ttl=61 time=4.04 ms
64 bytes from 9.9.9.9: icmp_seq=5 ttl=61 time=42.3 ms

--- 9.9.9.9 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4007ms
rtt min/avg/max/mdev = 4.043/11.891/42.353/15.232 ms
 ```

 Congratulations, at this point you have a working 5GC SA setup based on Open5GS + UERANSIM. :+1: 

# Optional: Vagrantfile walkthrough 
TODO

