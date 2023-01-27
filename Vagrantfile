# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|

  config.vagrant.plugins = "vagrant-reload"
  config.vm.box = "generic/fedora37"
  config.vm.provider :vmware_desktop

  config.vm.base_mac = "52540089e2f0"
  config.vm.base_address = "172.16.226.10"
  
  #config.vm.synced_folder ".", "/home/vagrant/workspace", id: "vagrant", automount: true
  config.vm.provider "vmware_desktop" do |v|
    v.gui = true
    v.linked_clone = false
    v.nat_device = "vmnet8"
    v.vmx["memsize"] = "32768"
    v.vmx["numvcpus"] = "8"
    v.vmx["cpuid.coresPerSocket"] = "2"
    v.vmx["vhv.enable"] = "TRUE"
    v.vmx["virtualhw.version"] = "20"
    v.vmx["vmx.buildType"] = "release"
  end

  config.vm.provision :shell do |s|
    s.privileged = true
    s.path = 'vagrant/scripts/fedora/update.sh'
  end

  config.vm.provision :shell do |s|
    s.privileged = true
    s.path = 'vagrant/scripts/fedora/config.sh'
  end

  config.vm.provision :shell do |s|
    s.privileged = true
    s.path = 'vagrant/scripts/fedora/virtualization.sh'
  end

  config.vm.provision :shell do |s|
    s.privileged = false
    s.path = 'vagrant/scripts/fedora/brew.sh'
  end

  config.vm.provision :reload

  config.vm.provision :shell do |s|
    s.privileged = false
    s.path = 'vagrant/scripts/dns.sh'
  end

  config.vm.provision :shell do |s|
    s.privileged = false
    s.env = {GIT_TOKEN:ENV['GIT_TOKEN'], GIT_REPO:ENV['GIT_REPO']}
    s.path = 'vagrant/scripts/k8s.sh'
  end

  config.vm.provision :shell do |s|
    s.privileged = false
    s.env = {GIT_TOKEN:ENV['GIT_TOKEN'], GIT_REPO:ENV['GIT_REPO']}
    s.path = 'vagrant/scripts/envs.sh'
  end

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    /home/linuxbrew/.linuxbrew/bin/kubectl port-forward -n argocd svc/argocd-server 8080:80 --kubeconfig ~/.kube/clusters/argo.config & echo "argocd port open"

    /home/linuxbrew/.linuxbrew/bin/argocd login localhost:8080 --username admin --password $(/home/linuxbrew/.linuxbrew/bin/kubectl -n argocd get secret argocd-initial-admin-secret --kubeconfig ~/.kube/clusters/argo.config -o jsonpath="{.data.password}" | base64 -d) --insecure
    #/home/linuxbrew/.linuxbrew/bin/argocd cluster add $( /home/linuxbrew/.linuxbrew/bin/kubectl config current-context --kubeconfig ~/.kube/clusters/infra.config  ) --name infra --yes --annotation cluster=infra --label templarfelix/monitoring-server=true --label templarfelix/basic=true --label templarfelix/kafka=true  --kubeconfig ~/.kube/clusters/infra.config  
    #/home/linuxbrew/.linuxbrew/bin/argocd cluster add $( /home/linuxbrew/.linuxbrew/bin/kubectl config current-context --kubeconfig ~/.kube/clusters/client-demo-sa-east-1.config  ) --name client-demo-sa-east-1 --yes --annotation cluster=client-demo-sa-east-1 --label templarfelix/mesh=true  --label templarfelix/monitoring-client=true --label templarfelix/third-party=true --label templarfelix/microservices=true  --kubeconfig ~/.kube/clusters/client-demo-sa-east-1.config 
    #/home/linuxbrew/.linuxbrew/bin/argocd cluster add $( /home/linuxbrew/.linuxbrew/bin/kubectl config current-context --kubeconfig ~/.kube/clusters/client-demo-us-east-1.config  ) --name client-demo-us-east-1 --yes --annotation cluster=client-demo-us-east-1 --label templarfelix/mesh=true  --label templarfelix/monitoring-client=true --label templarfelix/third-party=true --label templarfelix/microservices=true  --kubeconfig ~/.kube/clusters/client-demo-us-east-1.config 
  SHELL
  

end
