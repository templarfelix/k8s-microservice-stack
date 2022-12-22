#!/bin/sh
echo export KUBECONFIG="$(find ~/.kube/clusters -type f | sed ':a;N;s/\n/:/;ba')" >> /home/vagrant/.zshrc
echo export GIT_TOKEN="${GIT_TOKEN}" >> /home/vagrant/.zshrc
echo export GIT_REPO="${GIT_REPO}" >> /home/vagrant/.zshrc