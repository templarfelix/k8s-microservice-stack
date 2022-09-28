# POC argocd-autopilot
A Complete Microservice Kubernetes Stack

## ALL docs is going increase in next weeks

# pre-setup

## SETUP LINUX(FEDORA) FOR K8S
```bash
sudo sysctl  fs.inotify.max_queued_events=1048576
sudo sysctl  fs.inotify.max_user_instances=1048576
sudo sysctl  fs.inotify.max_user_watches=1048576
sudo sysctl -p
```

## INSTALL libvirt ON FEDORA
```bash
dependencies=$(sudo dnf repoquery --qf "%{name}" $(for dep in $(sudo dnf repoquery --depends vagrant-libvirt 2>/dev/null | cut -d' ' -f1); do echo "--whatprovides ${dep} "; done) 2>/dev/null)
sudo dnf install @virtualization ${dependencies}
sudo dnf remove vagrant-libvirt
sudo systemctl enable --now libvirtd
vagrant plugin install vagrant-libvirt
sudo usermod -a -G libvirt $USER
```

## INSTALL VAGRANT on FEDORA
```bash
sudo dnf install vagrant
```

## SETUP ENV
```bash
## TODO
```


# GET K8S CREDENTIALS
```bash
mkdir -p ~/.kube
mkdir -p ~/.kube/clusters
vagrant ssh argo -c "sudo cat /etc/kubernetes/admin.conf" > ~/.kube/clusters/argo.config
vagrant ssh infra -c "sudo cat /etc/kubernetes/admin.conf" > ~/.kube/clusters/infra.config
vagrant ssh client-demo-sa-east-1 -c "sudo cat /etc/kubernetes/admin.conf" > ~/.kube/clusters/client-demo-sa-east-1.config
vagrant ssh client-demo-us-east-1 -c "sudo cat /etc/kubernetes/admin.conf" > ~/.kube/clusters/client-demo-us-east-1.config

export KUBECONFIG=$(find ~/.kube/clusters -type f | sed ':a;N;s/\n/:/;ba')
```

# INSTALL ARGOCD USING AUTOPILOT
```bash
# recovery
argocd-autopilot repo bootstrap  --recover --kubeconfig  ~/.kube/clusters/argo.config

# add current clusters
argocd-autopilot project create infra --dest-kube-context infra --port-forward --port-forward-namespace argocd --name infra --repo https://github.com/templarfelix-org/argocd-autopilot.git --yes
argocd-autopilot project create client1-sa-east-1 --dest-kube-context client1-sa-east-1 --port-forward --port-forward-namespace argocd --name client1-sa-east-1 --repo https://github.com/templarfelix-org/argocd-autopilot.git --yes
argocd-autopilot project create client1-us-east-1 --dest-kube-context client1-us-east-1 --port-forward --port-forward-namespace argocd --name client1-us-east-1 --repo https://github.com/templarfelix-org/argocd-autopilot.git --yes

# add new clusters
argocd-autopilot project create **CLUSTER** --dest-kube-context **CLUSTER** --port-forward --port-forward-namespace argocd --name **CLUSTER** --repo https://github.com/templarfelix-org/argocd-autopilot.git


```

# label clusters
```bash

kubectl label secrets cluster-TODO templarfelix/monitoring-server="true" --overwrite --namespace argocd
kubectl label secrets cluster-TODO templarfelix/monitoring-server="true" --overwrite --namespace argocd


```

# Get grafana auth
```bash
kubectl get secret monitoring-grafana -o jsonpath="{.data.admin-password}" --namespace monitoring --context infra | base64 --decode ; echo
```

# Custom integrations

REPLACE: TEMPLARFELIX_CUSTOM_* FOR YOUR INTEGRATIONS SECRETS