#!/bin/sh
pwd
git clone https://github.com/templarfelix/k8s-microservice-stack.git
cd k8s-microservice-stack
cd env
pwd

vagrant plugin install vagrant-libvirt
vagrant up
pwd

sleep 5m

mkdir -p ~/.kube
mkdir -p ~/.kube/clusters
vagrant ssh argo -c "sudo cat /etc/kubernetes/admin.conf" > ~/.kube/clusters/argo.config
/home/linuxbrew/.linuxbrew/bin/argocd-autopilot repo bootstrap --recover --kubeconfig  ~/.kube/clusters/argo.config --git-token ${GIT_TOKEN} --repo ${GIT_REPO}
sleep 5m
vagrant ssh infra -c "sudo cat /etc/kubernetes/admin.conf" > ~/.kube/clusters/infra.config
vagrant ssh client-demo-sa-east-1 -c "sudo cat /etc/kubernetes/admin.conf" > ~/.kube/clusters/client-demo-sa-east-1.config
vagrant ssh client-demo-us-east-1 -c "sudo cat /etc/kubernetes/admin.conf" > ~/.kube/clusters/client-demo-us-east-1.config