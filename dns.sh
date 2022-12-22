#!/bin/sh
#sudo dnf -y remove dnsmasq
sudo dnf -y install bind bind-utils
sudo systemctl enable named --now

sudo firewall-cmd --add-service=dns --permanent
sudo firewall-cmd --add-service=dhcp --permanent
sudo firewall-cmd --reload

sudo sed -e "s:allow-query.*:allow-query { 192.169.0.0/16;  172.16.0.0/16; localhost; };:g" \
    -e "s:listen-on port .*:listen-on port 53 { 172.16.226.10; };:g" \
    -i /etc/named.conf
sudo systemctl restart named
sudo systemctl restart dnsmasq

# FIXME TEM Q CORRIGIR dnsmasq 

## REMOVER
sudo rm -rf /etc/resolv.conf
cat <<EOF | sudo tee -a /etc/resolv.conf
nameserver 127.0.0.53
nameserver 172.16.226.10
options edns0 trust-ad
search localdomain
EOF
    
cat <<EOF | sudo tee -a /etc/named.conf
include "/etc/named.k8s.zones";
EOF

sudo rm -rf /etc/named.k8s.zones
cat <<EOF | sudo tee -a /etc/named.k8s.zones
key "externaldns-key" {
  algorithm hmac-sha256;
  secret "96Ah/a2g0/nLeFGK+d/0tzQcccf9hCEIy34PoXX2Qg8=";
};
zone "templarfelix.local" {
    type master;
    file "templarfelix.local.zone";
    allow-transfer {
        key "externaldns-key";
    };
    update-policy {
        grant externaldns-key zonesub ANY;
    };
};
EOF

sudo rm -rf /var/named/templarfelix.local.zone
cat <<EOF | sudo tee -a /var/named/templarfelix.local.zone
\$TTL 60
@ IN SOA templarfelix.local root.templarfelix.local (
  16
  60
  60
  60
  0
)

@      IN NS server
server IN A  192.168.184.131
EOF

sudo rm -rf /var/named/templarfelix.local.zone
cat <<EOF | sudo tee -a /var/named/templarfelix.local.zone
$TTL 60 ; 1 minute
@         IN SOA  templarfelix.local. root.templarfelix.local. (
                                16         ; serial
                                60         ; refresh (1 minute)
                                60         ; retry (1 minute)
                                60         ; expire (1 minute)
                                60         ; minimum (1 minute)
                                )
                        NS      ns.templarfelix.local.
ns                    A       1.1.1.1
EOF

sudo systemctl restart named
sudo systemctl restart dnsmasq

# DEBUG
journalctl -xeu named.service

sudo systemctl status named
sudo systemctl status dnsmasq



nslookup server.templarfelix.local
nslookup 172.16.226.10

dig -x templarfelix.local
sudo nslookup kafka-bootstrap.templarfelix.local.

dig templarfelix.local ANY +noall +answer

sudo nslookup kafka-broker-0.templarfelix.local.