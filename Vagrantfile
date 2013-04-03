# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "squeeze64"
  config.vm.box_url = "http://dl.dropbox.com/u/937870/VMs/squeeze64.box"

  config.vm.customize ["modifyvm", :id, "--memory", 1024]

  config.vm.network :hostonly, "192.168.21.100"

  config.vm.forward_port 80, 8080
  config.vm.forward_port 22, 2222
  config.vm.forward_port 3306, 3307

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "lamp.pp"
  end

  config.ssh.timeout = 30
end
