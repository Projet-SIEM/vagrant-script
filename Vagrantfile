# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.box = "CaptainMex/siemmail"

  config.vm.network "forwarded_port", guest: 80,  host: 2080
  config.vm.network "forwarded_port", guest: 8080,  host: 2081
  config.vm.network "forwarded_port", guest: 443, host: 2443

  config.vm.network "forwarded_port", guest: 3306, host: 3306
  config.vm.network "forwarded_port", guest: 3000,  host: 3000   # Dashboard
  config.vm.network "forwarded_port", guest: 8086, host: 8086  # Dashboard database


  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  config.vm.provider "virtualbox"

  config.vm.provision "shell", path: "roby.sh", keep_color: true
end
