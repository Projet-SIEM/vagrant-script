#!/bin/bash

# check if the virtualbox guest addition is install
if ! [ -a ./vbox ]; then
  sudo su
  echo deb http://ftp.debian.org/debian stretch-backports main contrib > /etc/apt/sources.list.d/stretch-backports.list
  apt update
  apt install virtualbox-guest-dkms virtualbox-guest-x11 linux-headers-$(uname -r) -y
  echo "The virtualbox guest addition is now installed, please reload the vm"
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

# Clone logcheck configurator if needed
if [ ! -d "logcheck" ]; then
  git clone https://github.com/Projet-SIEM/logcheck.git
fi

cd Malilog
# Update Malilog if needed
git checkout master && git up;

# launch log generation
java -jar malilog.jar -nb 20

# config logcheck
cd ../logcheck

# update logcheck configuration script if needed
git checkout master && git up

# conf logcheck
sudo ./conf.sh

# conf logcheck rules
#./rules.sh
# clean rules
sudo rm /etc/logcheck/ignore.d.server/local-rule
sudo echo "\[[0-9]{4}-[0-9]{2}-[0-9]{2}\s[0-9]{2}:[0-9]{2}:[0-9]{2}\]\s[a-z,A-Z]*\s[a-z,A-Z]*\s+([0-9]{1,3}\.){3}[0-9]{1,3}\s+([0-9]{1,3}\.){3}[0-9]{1,3}\s+[0-9]{1,5}\s[0-9]{1,5}\sConnection to server" >> /etc/logcheck/ignore.d.server/local-rule

cd .. && cp ./Malilog/Logs/logs.log /vagrant
