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

if [ ! -d "grafana-dashboard" ]; then
  git clone https://github.com/Projet-SIEM/grafana-dashboard.git
fi

cd grafana-dashboard
git checkout master && git up;

if [ ! "grafana" ]; then
  sudo ./grafana_install.sh
  touch grafana
fi
cd ..

cd Malilog
# Update Malilog if needed
git checkout master && git up;

# launch log generation
java -jar malilog.jar -nb 20

if [ ! -d "Logs/logs.log" ]; then

  cd ../grafana-dashboard
  python3 log_to_bdd.py ../Malilog/Logs/logs.log
fi

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

# run logcheck for the dashboard
sudo -u logcheck logcheck -t -o > /tmp/logcheck-report.txt

python3 /home/vagrant/grafana-dashboard/alert_to_bdd.py /tmp/logcheck-report.txt

# logcheck run
echo "Run logcheck" && sudo -u logcheck logcheck
echo "logcheck finish, fetch logs"
cd .. && cp ./Malilog/Logs/logs.log /vagrant
