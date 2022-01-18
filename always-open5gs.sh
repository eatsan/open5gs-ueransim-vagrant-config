#!/bin/bash

# THIS SCRIPT WILL BE PROVISIONED EVERYTIME OPEN5GS VM is run by the Vagrant.

echo "--- Adding a route for the UE to have WAN connectivity over SGi/N6 -------"
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1
iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE
ip6tables -t nat -A POSTROUTING -s 2001:db8:cafe::/48 ! -o ogstun -j MASQUERADE

echo "---- Restart UPFD & SMFD in case vagrant network configuration triggered SIGTERM on them -----"
systemctl restart open5gs-upfd
systemctl restart open5gs-smfd
