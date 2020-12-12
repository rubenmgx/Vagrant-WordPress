# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "wordpress" do |wordpress|
    wordpress.vm.box = "ubuntu/bionic64"
    wordpress.vm.hostname = "wordpress"
    wordpress.vm.network "private_network", ip: "192.168.100.3", nic_type: "virtio", virtualbox__intnet: "internal_network"
	wordpress.vm.network "forwarded_port", guest: 80, host: 8080
	wordpress.vm.provider "virtualbox" do |v|
		v.memory = 2048
		v.cpus = 1
		v.default_nic_type = "virtio"
	end
    wordpress.vm.provision "shell", path: "cofiguration_wordpress.sh"
  end
end