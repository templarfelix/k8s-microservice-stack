# k8s microservice stack

## _A Complete Microservice Stack for Kubernetes_

> The ideia of this project is simulate 3 enviroments 2 for client and one for infra tools
> This project use ArgoCD for install applications on enviroments  
> kubernetes cluster argo: cluster used for argocd deployment
> kubernetes cluster infra: receive kafka and all monitoring tools
> kubernetes clusters client-demo-sa-east-1: receive microservices and monitoring tools for simulate a region SA
> kubernetes clusters client-demo-us-east-1: receive microservices and monitoring tools for simulate a region US

# This project use

## Infra

### Vmware
[Vmware Workstation](https://www.vmware.com/br/products/workstation-pro.html)

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
#### Event Streaming
[Strimzi](https://github.com/strimzi/strimzi-kafka-operator/)

### Test
[Kafka Stress](https://github.com/msfidelis/kafka-stress)

# pre-setup

## SETUP Variables
GIT_REPO a Fork url for this repositorie
GIT_TOKEN a Token for argocd get resources from git

Make sure to have a [valid token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

examples:
```bash
export GIT_REPO = https://github.com/templarfelix/k8s-microservice-stack.git
export GIT_TOKEN = xxxxx
```

## INSTALL VAGRANT on FEDORA
```bash

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

# add cluster infra with monitoring-server basic and kafka
argocd cluster add $( kubectl config current-context  --kubeconfig ~/.kube/clusters/infra.config  ) --name infra --yes --annotation cluster=infra --label templarfelix/monitoring-server=true --label templarfelix/basic=true --label templarfelix/kafka=true  --kubeconfig ~/.kube/clusters/infra.config 

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
templarfelix/basic="true" 
templarfelix/monitoring-server="true"
templarfelix/monitoring-client="true"
templarfelix/third-party="true" 
templarfelix/kafka="true"
templarfelix/microservices="true" 
templarfelix/mesh="true" 
```

# Get grafana auth
```bash
kubectl get secret monitoring-grafana -o jsonpath="{.data.admin-password}" --namespace monitoring --context infra | base64 --decode ; echo
```

# Custom integrations

REPLACE: TEMPLARFELIX_CUSTOM_* FOR YOUR INTEGRATIONS SECRETS

## TODO
 add docs about how labels work
 