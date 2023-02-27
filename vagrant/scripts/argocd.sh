#!/bin/sh
/home/linuxbrew/.linuxbrew/bin/argocd-autopilot repo bootstrap --recover --kubeconfig  ~/.kube/clusters/argo.config --git-token ${GIT_TOKEN} --repo ${GIT_REPO}
sleep 5m