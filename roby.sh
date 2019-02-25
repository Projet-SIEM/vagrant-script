#!/bin/bash

# fix issue
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

# Check if git is not installed
if  ! git="$(type -p git)" || [[ -z $git ]]; then
  echo "Git install : "
  apt install git -y
fi

# add usefull git alias
git config --global alias.up '!git remote update -p; git merge --ff-only @{u}'

# Check if logcheck is not installed
if ! logcheck="$(type -p logcheck)" || [[ -z $logcheck ]]; then
  echo "logcheck install : "
  apt install logcheck -y
fi

# Check if java is not installed
if ! java="$(type -p java)" || [[ -z $java ]]; then
  echo "Java install : "
  apt install default-jdk -y
fi

# Clone Malilog if needed
if [ ! -d "Malilog" ]; then
  echo "Cloning Malilog : "
  git clone https://github.com/Projet-SIEM/Malilog.git
fi

# Clone logcheck configurator if needed
if [ ! -d "logcheck" ]; then
  echo "Cloning logcheck config script : "
  git clone https://github.com/Projet-SIEM/logcheck.git
fi

if [ ! -d "grafana-dashboard" ]; then
  echo "Cloning dashboard : "
  git clone https://github.com/Projet-SIEM/grafana-dashboard.git
fi

cd grafana-dashboard
git checkout master && git up;

if [ ! -f "grafana" ]; then
  echo "Install grafana dashboard : "
  sudo ./grafana_install.sh
  touch grafana
fi
echo "Grafana already install"
cd ..

cd Malilog
# Update Malilog if needed
echo "Update Malilog : "
git checkout master && git up;

# launch log generation
if [ ! $# -eq 0 ]; then
  java -jar malilog.jar -nbar -nb $1
else
  java -jar malilog.jar -nbar -nb 10
fi

if [ ! -d "Logs/logs.log" ]; then
  echo "Add log to the dashboard : "
  cd ../grafana-dashboard
  python3 log_to_bdd.py ../Malilog/Logs/logs.log
fi

# config logcheck
cd ../logcheck

# update logcheck configuration script if needed
git checkout master && git up

# conf logcheck
echo "config logcheck : "
sudo ./conf.sh

# conf logcheck rules
if [ -f "/etc/logcheck/cracking.d/local-rule" ]; then
  echo "clean rules : "
  sudo rm /etc/logcheck/cracking.d/local-rule
fi

echo "add rules : "
if [ -f "/vagrant/rules.txt" ]; then
  sudo cp /vagrant/rules.txt /etc/logcheck/cracking.d/local-rule
else
  echo "No rules file found, did you run rules.py ?"
fi
echo "Run logcheck for the dashboard : "
sudo -u logcheck logcheck -t -o > /tmp/logcheck-report.txt
python3 /home/vagrant/grafana-dashboard/alert_to_bdd.py /tmp/logcheck-report.txt

# logcheck run
echo "Run logcheck" && sudo -u logcheck logcheck
echo "logcheck finish, fetch logs"
cd .. && cp ./Malilog/Logs/logs.log /vagrant
