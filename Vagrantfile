# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "debian/stretch64"


  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  config.vm.network "public_network"

  # http port forwarding
  config.vm.network "forwarded_port", guest: 80,  host: 2080
  config.vm.network "forwarded_port", guest: 443, host: 2443

  # dns port forwarding
  config.vm.network "forwarded_port", guest: 53, host: 53

  # email port forwarding
  config.vm.network "forwarded_port", guest: 25,  host: 25   # SMTP
  config.vm.network "forwarded_port", guest: 110, host: 110  # POP3
  config.vm.network "forwarded_port", guest: 143, host: 143  # IMAP
  config.vm.network "forwarded_port", guest: 465, host: 465  # Secure SMTP (SSMTP)
  config.vm.network "forwarded_port", guest: 585, host: 585  # Secure IMAP (IMAP4-SSL)
  config.vm.network "forwarded_port", guest: 993, host: 993  # IMAP4 over SSL
  config.vm.network "forwarded_port", guest: 995, host: 995  # Secure POP3 (SSL-POP)

  # Dashboard specific port forwarding
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
  # Uncomment to use this provider but the two-way share folder will not work (need to use virtualbox provider)
  #config.vm.provider "libvirt"
  #config.vm.provider "docker"
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
   config.vm.provision "shell", path: "roby.sh"
end
