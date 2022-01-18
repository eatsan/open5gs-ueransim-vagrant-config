#!/bin/bash

# THIS SCRIPT WILL BE PROVISIONED EVERYTIME UERANSIM VM is run by the Vagrant.
echo "------ Starting UERANSIM gNB in a screen with the given config ---------"
echo "------ You can connect back to the running gNB instance via sudo screen -r ueransim-gnb"
screen -S ueransim-gnb -dm  /home/vagrant/UERANSIM/build/nr-gnb -c /home/vagrant/UERANSIM/config/open5gs-gnb.yaml
