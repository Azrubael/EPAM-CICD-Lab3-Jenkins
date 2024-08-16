# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
  
  ### ----- Silver vm ----- Should start first
  config.vm.define "silver" do |silver|
    silver.vm.box = "ubuntu/bionic64"
    silver.vm.hostname = "silver"
    silver.vm.network "private_network", ip: "192.168.56.18"
    silver.vm.synced_folder ".", "/vagrant", disabled: false
    silver.vm.provider "virtualbox" do |ubuntu18|
      ubuntu18.name = "silver-ubuntu18"
      ubuntu18.memory = "2500"
      ubuntu18.cpus = 1
      ubuntu18.customize ["modifyvm", :id, "--vram", "16"]
    end
    silver.vm.provision "file", source: ".env/mkey.pub", destination: "/tmp/mkey.pub"
    silver.vm.provision "shell", path: "scripts/silver-setup.sh"  
  end
  

  ### ----- Merlin vm ----- Should start first
  config.vm.define "merlin" do |merlin|
    merlin.vm.box = "ubuntu/focal64"
    merlin.vm.hostname = "merlin"
    merlin.vm.network "private_network", ip: "192.168.56.20"
    merlin.vm.synced_folder ".", "/vagrant", disabled: false
    merlin.vm.provider "virtualbox" do |ubuntu20|
      ubuntu20.name = "merlin-ubuntu20"
      ubuntu20.memory = "4500"
      ubuntu20.cpus = 2
      ubuntu20.customize ["modifyvm", :id, "--vram", "16"]
    end
    merlin.vm.provision "file", source: ".env/mkey", destination: "/tmp/mkey"
    merlin.vm.provision "shell", path: "scripts/merlin-setup.sh"  
  end
  
end
