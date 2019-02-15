#!/bin/bash

# fix issue
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

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
# clean rules
sudo rm /etc/logcheck/cracking.d/local-rule

# add rules
sudo cp /vagrant/rules.txt /etc/logcheck/cracking.d/local-rule

# logcheck run
echo "Run logcheck" && sudo -u logcheck logcheck
echo "logcheck finish, fetch logs"
cd .. && cp ./Malilog/Logs/logs.log /vagrant
