# k8s microservice stack

## _A Complete Microservice Stack for Kubernetes_

> The ideia of this project is simulate 3 enviroments 2 for clientes and one for infra tools  
> This project use ArgoCD for install applications on enviroments  
> cluster argo: 
> cluster infra: receive kafka and all monitoring tools
> clusters client-demo-sa-east-1 & client-demo-us-east-1: receive 

# This project use

## Infra
### Vagrant
[Alvistack Kubernetes 1.25](https://github.com/alvistack/vagrant-kubernetes/)

### Kubernetes
#### CD
[ArgoCD Autopilot](https://github.com/argoproj-labs/argocd-autopilot/)
[ArgoCD](https://github.com/argoproj/argo-cd/)
#### Workflows
[Argo Workflows](https://github.com/argoproj/argo-workflows/)
#### Canary & Blue-Green
[Argo Rollouts](https://github.com/argoproj/argo-rollouts/)
#### Others
[Argo Events](https://github.com/argoproj/argo-events/)
[Cert Manager](https://github.com/cert-manager/cert-manager/)
[External Secrets](https://github.com/external-secrets/external-secrets/)
[Istio](https://github.com/istio/istio/)
[Keda](https://github.com/kedacore/keda/)
[OpentenTelemetry Operator](https://github.com/open-telemetry/opentelemetry-operator/)
[Strimzi](https://github.com/strimzi/strimzi-kafka-operator/)

 
### Test
[Kafka Stress](https://github.com/msfidelis/kafka-stress)

# pre-setup

## SETUP LINUX(FEDORA) FOR K8S
```bash
sudo sysctl  fs.inotify.max_queued_events=1048576
sudo sysctl  fs.inotify.max_user_instances=1048576
sudo sysctl  fs.inotify.max_user_watches=1048576
sudo sysctl -p
```

## INSTALL VAGRANT on FEDORA
```bash
sudo dnf install vagrant
vagrant plugin install vagrant-libvirt
```

## INSTALL libvirt ON FEDORA
```bash
dependencies=$(sudo dnf repoquery --qf "%{name}" $(for dep in $(sudo dnf repoquery --depends vagrant-libvirt 2>/dev/null | cut -d' ' -f1); do echo "--whatprovides ${dep} "; done) 2>/dev/null)
sudo dnf install @virtualization ${dependencies}
sudo dnf remove vagrant-libvirt
sudo systemctl enable --now libvirtd
sudo usermod -a -G libvirt $USER
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

# INSTALL THIS PROJECT USING ARGOCD AUTOPILOT

for this you need 2 env's GIT_TOKEN AND GIT_REPO more detail in: https://argocd-autopilot.readthedocs.io/en/stable/Getting-Started/

GIT_REPO = YOUR FORK OF THIS PROJECT

```bash
# recovery using your fork
argocd-autopilot repo bootstrap  --recover --kubeconfig  ~/.kube/clusters/argo.config

kubectl port-forward -n argocd svc/argocd-server 8080:8080  --kubeconfig ~/.kube/clusters/argo.config 

# login with argo cli
argocd login localhost:8080 --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d) --insecure

# add cluster infra with monitoring-server thirdy-party  and kafka
argocd cluster add $( kubectl config current-context  --kubeconfig ~/.kube/clusters/infra.config  ) --name infra --yes --annotation cluster=infra --label templarfelix/monitoring-server=true --label templarfelix/third-party=true --label templarfelix/kafka=true  --kubeconfig ~/.kube/clusters/infra.config 

# add cluster client-demo-sa-east-1
argocd cluster add $( kubectl config current-context  --kubeconfig ~/.kube/clusters/client-demo-sa-east-1.config  ) --name client-demo-sa-east-1 --yes --annotation cluster=client-demo-sa-east-1 --label templarfelix/monitoring-client=true --label templarfelix/third-party=true --label templarfelix/microservices=true  --kubeconfig ~/.kube/clusters/client-demo-sa-east-1.config 
# add cluster client-demo-us-east-1
argocd cluster add $( kubectl config current-context  --kubeconfig ~/.kube/clusters/client-demo-us-east-1.config  ) --name client-demo-us-east-1 --yes --annotation cluster=client-demo-us-east-1 --label templarfelix/monitoring-client=true --label templarfelix/third-party=true --label templarfelix/microservices=true  --kubeconfig ~/.kube/clusters/client-demo-us-east-1.config 
```

# recovery password from argocd admin
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

# label availables for argo clusters
```bash
templarfelix/monitoring-server="true"
templarfelix/third-party="true" 
templarfelix/kafka="true"
templarfelix/microservices="true" 
```

# Get grafana auth
```bash
kubectl get secret monitoring-grafana -o jsonpath="{.data.admin-password}" --namespace monitoring --context infra | base64 --decode ; echo
```

# Custom integrations

REPLACE: TEMPLARFELIX_CUSTOM_* FOR YOUR INTEGRATIONS SECRETS

## TODO
 add docs about how labels work
 