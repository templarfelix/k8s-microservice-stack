# -*- mode: ruby -*-
# vi: set ft=ruby :

$script =  <<SCRIPT
  echo "init"
  ## sudo apt update
SCRIPT

Vagrant.configure("2") do |config|



  config.vm.box = "alvistack/kubernetes-1.25"
  config.nfs.verify_installed = false
  config.vm.synced_folder '.', '/vagrant', type: 'rsync', rsync__exclude: ".git/", disabled: false

  config.vm.provider :libvirt do |libvirt|
    libvirt.management_network_name = "argo"
    libvirt.management_network_address = "192.169.0.0/16"
	end

  config.vm.define "argo" do |argo|

    argo.vm.hostname = "argo"
    argo.vm.provision "shell", inline: $script, privileged: false

    argo.vm.provider :libvirt do |libvirt|
      #libvirt.cpu_mode = 'host-passthrough'
      libvirt.cpus = 8
      libvirt.disk_bus = 'virtio'
      libvirt.disk_driver :cache => 'writeback'
      libvirt.driver = 'kvm'
      libvirt.memory = 16384
      #libvirt.memorybacking :access, :mode => 'shared'
      libvirt.nested = true
      libvirt.nic_model_type = 'virtio'
      libvirt.storage :file, bus: 'virtio', cache: 'writeback'
      libvirt.video_type = 'virtio'
      
    end

  end

  config.vm.define "infra" do |infra|

    infra.vm.hostname = "infra"
    infra.vm.provision "shell", inline: $script, privileged: false

    infra.vm.provider :libvirt do |libvirt|
      #libvirt.cpu_mode = 'host-passthrough'
      libvirt.cpus = 8
      libvirt.disk_bus = 'virtio'
      libvirt.disk_driver :cache => 'writeback'
      libvirt.driver = 'kvm'
      libvirt.memory = 16384
      #libvirt.memorybacking :access, :mode => 'shared'
      libvirt.nested = true
      libvirt.nic_model_type = 'virtio'
      libvirt.storage :file, bus: 'virtio', cache: 'writeback'
      libvirt.video_type = 'virtio'
    end

  end 

  config.vm.define "client-demo-sa-east-1" do |client|

    client.vm.hostname = "client-demo-sa-east-1"
    client.vm.provision "shell", inline: $script, privileged: false

    client.vm.provider :libvirt do |libvirt|
      #libvirt.cpu_mode = 'host-passthrough'
      libvirt.cpus = 8
      libvirt.disk_bus = 'virtio'
      libvirt.disk_driver :cache => 'writeback'
      libvirt.driver = 'kvm'
      libvirt.memory = 16384
      #libvirt.memorybacking :access, :mode => 'shared'
      libvirt.nested = true
      libvirt.nic_model_type = 'virtio'
      libvirt.storage :file, bus: 'virtio', cache: 'writeback'
      libvirt.video_type = 'virtio'
    end

  end 

  config.vm.define "client-demo-us-east-1" do |client|

    client.vm.hostname = "client-demo-us-east-1"
    client.vm.provision "shell", inline: $script, privileged: false

    client.vm.provider :libvirt do |libvirt|
      #libvirt.cpu_mode = 'host-passthrough'
      libvirt.cpus = 8
      libvirt.disk_bus = 'virtio'
      libvirt.disk_driver :cache => 'writeback'
      libvirt.driver = 'kvm'
      libvirt.memory = 16384
      #libvirt.memorybacking :access, :mode => 'shared'
      libvirt.nested = true
      libvirt.nic_model_type = 'virtio'
      libvirt.storage :file, bus: 'virtio', cache: 'writeback'
      libvirt.video_type = 'virtio'
      #libvirt.management_network_name = "argo"
      #libvirt.management_network_address = "192.168.104.0/24"
    end

  end 


end