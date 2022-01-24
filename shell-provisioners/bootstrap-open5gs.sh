#!/bin/bash

# THIS SCRIPT WILL BE PROVISIONED ONLY DURING THE FIRST vagrant up. 

# If you want to manually force re-provisioning without 
# recreating the VM use one of the following commands: 
#    $ vagrant provision open5gs 
#    OR 
#    $ vagrant up --provision open5gs 

echo "---------Installing Open5GS--------"
apt-get update
apt-get install -y software-properties-common
add-apt-repository -y -u  ppa:open5gs/latest
apt-get install -y open5gs curl
curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
apt-get install -y nodejs
curl -fsSL https://open5gs.org/open5gs/assets/webui/install | bash -
echo "---------Finished installing Open5GS ------"
echo "---------Installing yq for in-place YAML configuration editing -------"
if ! type "yq" > /dev/null; then
  # install yq here if not already installed
  (VERSION=v4.16.2; BINARY=yq_linux_amd64; wget -nv  "https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY}" -O /usr/bin/yq && chmod +x /usr/bin/yq)
fi

echo "--------Editing UPF & AMF configurations for NGAP & GTPU bind addresses of AMF and UPF modules"

if [ ! -f /etc/open5gs/amf.yaml.bkp ]
then
  cp /etc/open5gs/amf.yaml /etc/open5gs/amf.yaml.bkp
  ip_private=$1 tac=$2 yq eval 'with(.amf; .ngap[0].addr=env(ip_private) | with(.guami[0].plmn_id; .mcc=001 | .mnc=01) | with(.tai[0]; .plmn_id.mcc=001 | .plmn_id.mnc=01 | .tac=env(tac)) | with(.plmn_support[0].plmn_id; .mcc=001 | .mnc=01) )' -i  -I4 /etc/open5gs/amf.yaml
  diff -u /etc/open5gs/amf.yaml.bkp /etc/open5gs/amf.yaml 
  systemctl restart open5gs-amfd
else
  echo "No need to reconfigure AMF config. Skipping..."
fi

if [ ! -f /etc/open5gs/upf.yaml.bkp ]
then
 cp /etc/open5gs/upf.yaml /etc/open5gs/upf.yaml.bkp
 ip_private=$1 yq eval '.upf.gtpu[0].addr=env(ip_private)' -i -I4 /etc/open5gs/upf.yaml
 diff -u /etc/open5gs/upf.yaml.bkp /etc/open5gs/upf.yaml
 systemctl restart open5gs-upfd
else
  echo "No need to reconfigure UPF config. Skipping..."
fi

echo "--------Checking status of UPF & AMF services -------------"
systemctl status open5gs-amfd
systemctl status open5gs-upfd

echo "------- Add a test user in the UDM/UDR database ------"
open5gs-dbctl add "001010000000001" "465B5CE8B199B49FAA5F0A2EE238A6BC" "E8ED289DEBA952E4283B54E88E6183CA"


