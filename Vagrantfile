# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vagrant.plugins = "vagrant-reload"
  config.vm.box = "generic/fedora37"
  config.vm.provider :vmware_desktop
  config.vm.network "public_network", ip: "192.168.184.100"
  #config.vm.synced_folder ".", "/home/vagrant/workspace", id: "vagrant", automount: true
  config.vm.provider "vmware_desktop" do |v|
    v.gui = true
    v.linked_clone = false
    v.nat_device = "vmnet8"
    v.vmx["memsize"] = "32768"
    v.vmx["numvcpus"] = "16"
    v.vmx["cpuid.coresPerSocket"] = "2"
    v.vmx["vhv.enable"] = "TRUE"
    v.vmx["virtualhw.version"] = "19"
    v.vmx["vmx.buildType"] = "release"
  end

  config.vm.provision "shell", privileged: true, inline: <<-SHELL
    dnf update -y
    dnf install podman -y
    dnf install telnet -y
    dnf install terminator -y
    dnf install zsh -y
    dnf install helm -y
    dnf install kubectl -y
    dnf groupinstall "Pantheon Desktop" --skip-broken  -y 
    dnf groupinstall "Fedora Workstation" --skip-broken -y
    dnf groupinstall "Development Tools"  --skip-broken -y
  SHELL

  config.vm.provision "shell", privileged: true, inline: <<-SHELL
    systemctl set-default graphical.target
    systemctl enable gdm.service
    sysctl fs.inotify.max_queued_events=1048576
    sysctl fs.inotify.max_user_instances=1048576
    sysctl fs.inotify.max_user_watches=1048576
    sysctl -p
  SHELL

  config.vm.provision "shell", privileged: true, inline: <<-SHELL
    dependencies=$(dnf repoquery --qf "%{name}" $(for dep in $(dnf repoquery --depends vagrant-libvirt 2>/dev/null | cut -d' ' -f1); do echo "--whatprovides ${dep} "; done) 2>/dev/null)
    dnf install @virtualization ${dependencies} -y
    dnf remove vagrant-libvirt -y
    systemctl enable --now libvirtd
    usermod -a -G libvirt vagrant
    dnf install vagrant -y
  SHELL

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
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
    brew install kubectx
    brew install derailed/k9s/k9s
    #brew install operator-sdk
    #brew install kustomize
    #brew install helm
    #brew install go
    #brew install pulumi
    #brew install minikube
    #brew install htop
    brew install gotop
    #brew install quarkusio/tap/quarkus
    #brew install gradle
    #brew install glooctl
  SHELL

  config.vm.provision :reload

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    pwd
    git clone https://github.com/templarfelix-org/k8s-microservice-stack.git
    cd k8s-microservice-stack
    cd env
    vagrant plugin install vagrant-libvirt
    mkdir -p ~/.kube
    mkdir -p ~/.kube/clusters
    vagrant ssh argo -c "sudo cat /etc/kubernetes/admin.conf" > ~/.kube/clusters/argo.config
    vagrant up argocd
    sleep 5m
    /home/linuxbrew/.linuxbrew/bin/argocd-autopilot repo bootstrap --recover --kubeconfig  ~/.kube/clusters/argo.config --git-token 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 --repo https://github.com/templarfelix-org/k8s-microservice-stack.git
    vagrant up infra
    sleep 5m
    vagrant ssh infra -c "sudo cat /etc/kubernetes/admin.conf" > ~/.kube/clusters/infra.config
    #vagrant up client-demo-sa-east-1
    #vagrant ssh client-demo-sa-east-1 -c "sudo cat /etc/kubernetes/admin.conf" > ~/.kube/clusters/client-demo-sa-east-1.config
    #vagrant up client-demo-us-east-1
    #vagrant ssh client-demo-us-east-1 -c "sudo cat /etc/kubernetes/admin.conf" > ~/.kube/clusters/client-demo-us-east-1.config
    echo export KUBECONFIG="$(find ~/.kube/clusters -type f | sed ':a;N;s/\n/:/;ba')" >> /home/vagrant/.zshrc
  SHELL

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    # READY ONLY TOKEN
    echo export GIT_TOKEN="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" >> /home/vagrant/.zshrc
    echo export GIT_REPO="https://github.com/templarfelix-org/k8s-microservice-stack.git" >> /home/vagrant/.zshrc
  SHELL

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    sleep 5m
    /home/linuxbrew/.linuxbrew/bin/kubectl port-forward -n argocd svc/argocd-server 8080:80 --kubeconfig ~/.kube/clusters/argo.config & echo "argocd port open"
  SHELL

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    /home/linuxbrew/.linuxbrew/bin/argocd login localhost:8080 --username admin --password $(/home/linuxbrew/.linuxbrew/bin/kubectl -n argocd get secret argocd-initial-admin-secret --kubeconfig ~/.kube/clusters/argo.config -o jsonpath="{.data.password}" | base64 -d) --insecure
    /home/linuxbrew/.linuxbrew/bin/argocd cluster add $( /home/linuxbrew/.linuxbrew/bin/kubectl config current-context --kubeconfig ~/.kube/clusters/infra.config  ) --name infra --yes --annotation cluster=infra --label templarfelix/monitoring-server=true --label templarfelix/basic=true --label templarfelix/kafka=true  --kubeconfig ~/.kube/clusters/infra.config  
    #/home/linuxbrew/.linuxbrew/bin/argocd cluster add $( /home/linuxbrew/.linuxbrew/bin/kubectl config current-context --kubeconfig ~/.kube/clusters/client-demo-sa-east-1.config  ) --name client-demo-sa-east-1 --yes --annotation cluster=client-demo-sa-east-1 --label templarfelix/monitoring-client=true --label templarfelix/third-party=true --label templarfelix/microservices=true  --kubeconfig ~/.kube/clusters/client-demo-sa-east-1.config 
    #/home/linuxbrew/.linuxbrew/bin/argocd cluster add $( /home/linuxbrew/.linuxbrew/bin/kubectl config current-context --kubeconfig ~/.kube/clusters/client-demo-us-east-1.config  ) --name client-demo-us-east-1 --yes --annotation cluster=client-demo-us-east-1 --label templarfelix/monitoring-client=true --label templarfelix/third-party=true --label templarfelix/microservices=true  --kubeconfig ~/.kube/clusters/client-demo-us-east-1.config 
  SHELL

end
