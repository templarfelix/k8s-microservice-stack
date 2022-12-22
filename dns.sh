#!/bin/sh
sudo dnf -y install bind bind-utils
sudo systemctl enable named --now

sudo firewall-cmd --add-service=dns --permanent
sudo firewall-cmd --add-service=dhcp --permanent
sudo firewall-cmd --reload

sudo sed -e "s:allow-query.*:allow-query { any; };:g" \
    -e "s:listen-on port .*:listen-on port 53 { 172.16.226.10; };:g" \
    -i /etc/named.conf

sudo systemctl restart named
sudo systemctl restart dnsmasq

# FIXME TEM Q CORRIGIR dnsmasq para incluir o nameserver 172.16.226.10

## REMOVER WORKARROUND O DNS RESOLVER
sudo rm -rf /etc/resolv.conf
cat <<EOF | sudo tee -a /etc/resolv.conf
nameserver 172.16.226.10
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
zone "templarfelix.k8s" {
    type master;
    file "templarfelix.k8s.zone";
    allow-transfer {
        key "externaldns-key";
    };
    update-policy {
        grant externaldns-key zonesub ANY;
    };
};
EOF

sudo rm -rf /var/named/templarfelix.k8s.zone
cat <<EOF | sudo tee -a /var/named/templarfelix.k8s.zone
\$TTL 60
@ IN SOA templarfelix.k8s root.templarfelix.k8s (
  16
  60
  60
  60
  0
)

@      IN NS server
server IN A  192.168.184.131
EOF

sudo systemctl restart named
sudo systemctl restart dnsmasq

nslookup server.templarfelix.k8s
nslookup kafka-broker-0.templarfelix.k8s.

ping server.templarfelix.k8s
ping kafka-broker-0.templarfelix.k8s