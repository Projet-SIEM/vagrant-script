#!/bin/bash

# check if the virtualbox guest addition is install
if ! [ -a ./vbox ]; then
  sudo su
  echo deb http://ftp.debian.org/debian stretch-backports main contrib > /etc/apt/sources.list.d/stretch-backports.list
  apt update
  apt install virtualbox-guest-dkms virtualbox-guest-x11 linux-headers-$(uname -r)
  echo "The virtualbox guest addition is no installed, please reload the vm"
  touch vbox
  exit 1
fi

# Check if git is not installed
if  ! git="$(type -p git)" || [[ -z $git ]]; then
  apt install git -y
fi

# add usefull git alias
git config --global alias.up '!git remote update -p; git merge --ff-only @{u}'

# Check if logcheck is not installed
if ! logcheck="$(type -p logcheck)" || [[ -z $logcheck ]]; then
  apt install logcheck -y
fi

# Check if java is not installed
if ! java="$(type -p java)" || [[ -z $java ]]; then
  apt install default-jdk -y
fi

# Clone Malilog if needed
if [ ! -d "Malilog" ]; then
  git clone https://github.com/Projet-SIEM/Malilog.git
fi

cd Malilog
# Update Malilog if needed
git checkout master && git up;

# launch log generation
java -jar malilog.jar -nb 20

cp Logs/logs.log /vagrant
