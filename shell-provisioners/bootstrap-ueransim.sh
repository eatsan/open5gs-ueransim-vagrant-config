#!/bin/bash

# THIS SCRIPT WILL BE PROVISIONED ONLY DURING THE FIRST vagrant up. 

# If you want to manually force re-provisioning without 
# recreating the VM use one of the following commands: 
#    $ vagrant provision ueransim 
#    OR 
#    $ vagrant up --provision ueransim 

echo "----- Checking connectivity to the OPEN5GS VM -----"
nc -zvu $2 2152


echo "----- Compile & Install UERANSIM ------"
apt-get update
apt-get upgrade

apt-get install -y make gcc g++ libsctp-dev lksctp-tools iproute2 screen
snap install cmake --classic
cd /home/vagrant

if [ ! -d /home/vagrant/UERANSIM ]
then
  git clone https://github.com/aligungr/UERANSIM
else
  echo "No need to clone the git repo. Skipping..."
fi

cd /home/vagrant/UERANSIM
make
cd ./build
ls -al 

echo "---------Installing yq for in-place YAML configuration editing -------"
if ! type "yq" > /dev/null; then
  # install yq here if not already installed
  (VERSION=v4.16.2; BINARY=yq_linux_amd64; wget -nv  "https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY}" -O /usr/bin/yq && chmod +x /usr/bin/yq)
fi


echo "------- Modify the gNB & UE configuration files  -------"

if [ ! -f /home/vagrant/UERANSIM/config/open5gs-gnb.yaml.bkp ]
then
  cp /home/vagrant/UERANSIM/config/open5gs-gnb.yaml /home/vagrant/UERANSIM/config/open5gs-gnb.yaml.bkp
  gNBIP=$1 Open5GSIP=$2 TAC=$3  yq eval -i -I4 ' .mcc="001" | .mnc="01" | .tac=env(TAC) | .linkIp=env(gNBIP) | .ngapIp=env(gNBIP) | .gtpIp=env(gNBIP) | .amfConfigs[0].address=env(Open5GSIP)'  /home/vagrant/UERANSIM/config/open5gs-gnb.yaml
else
  echo "Skipping gNB configuration...Already provisioned..."
fi

if [ ! -f /home/vagrant/UERANSIM/config/open5gs-ue.yaml.bkp ]
then
   cp /home/vagrant/UERANSIM/config/open5gs-ue.yaml  /home/vagrant/UERANSIM/config/open5gs-ue.yaml.bkp
   gNBIP=$1 yq eval -i -I4 ' .supi="imsi-001010000000001" | .mcc="001" | .mnc="01" | .gnbSearchList[0]=env(gNBIP) ' /home/vagrant/UERANSIM/config/open5gs-ue.yaml
else
   echo "Skipping UE configuration...Already provisioned..."
fi


