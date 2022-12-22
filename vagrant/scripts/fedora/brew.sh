#!/bin/sh
sudo usermod -s $(which zsh) vagrant

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/vagrant/.zprofile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >> /home/vagrant/.zshrc

brew install kubernetes-cli
brew install argo
brew install argocd
brew install argocd-autopilot
brew install argoproj/tap/kubectl-argo-rollouts
brew install derailed/k9s/k9s
brew install kustomize
brew install helm
brew install gotop