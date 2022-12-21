#!/bin/sh
#sudo dnf -y remove dnsmasq
sudo dnf -y install bind bind-utils
sudo systemctl enable named --now

sudo systemctl status named
sudo firewall-cmd --add-service=dns --permanent
sudo firewall-cmd --reload

sudo sed -e "s:allow-query.*:allow-query { 192.169.0.0/16;  172.16.0.0/16; localhost; };:g" \
    -e "s:listen-on port .*:listen-on port 53 { 172.16.226.10; };:g" \
    -i /etc/named.conf
sudo systemctl restart named

# FIXME TEM Q CORRIGIR dnsmasq 

## REMOVER
#sudo rm -rf /etc/resolv.conf
#cat <<EOF | sudo tee -a /etc/resolv.conf
#nameserver 127.0.0.53
#options edns0 trust-ad
#search localdomain
#EOF
    
cat <<EOF | sudo tee -a /etc/named.conf
include "/etc/named.k8s.zones";
EOF

sudo rm -rf /etc/named.k8s.zones
cat <<EOF | sudo tee -a /etc/named.k8s.zones
key "externaldns-key" {
  algorithm hmac-sha256;
  secret "96Ah/a2g0/nLeFGK+d/0tzQcccf9hCEIy34PoXX2Qg8=";
};
zone "k8s.templarfelix.local" {
    type master;
    file "k8s.templarfelix.local.zone";
    allow-transfer {
        key "externaldns-key";
    };
    update-policy {
        grant externaldns-key zonesub ANY;
    };
};
EOF

sudo rm -rf /var/named/k8s.templarfelix.local.zone
cat <<EOF | sudo tee -a /var/named/k8s.templarfelix.local.zone
\$TTL 86400

@ IN SOA k8s.templarfelix.local root.k8s.templarfelix.local (
  2017010302
  3600
  900
  604800
  86400
)

@      IN NS server
server IN A  192.168.184.131
EOF