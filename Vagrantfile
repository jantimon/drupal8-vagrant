# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box       = 'precise32'
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.hostname = 'drupal-sandbox'

	# Allow apache to write into /vagrant
  config.vm.synced_folder ".", "/vagrant", :nfs => true


  # Cache APT packages outside of the vm
  config.vm.synced_folder "vagrant_setup/cache", "/var/cache/apt/archives/"

  # HTTP
  config.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true
  config.vm.network :private_network, ip: "10.11.12.13"


  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.provision :shell, :path => "vagrant_setup/config.sh"
end
