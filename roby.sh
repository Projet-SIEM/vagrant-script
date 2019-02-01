#!/bin/bash

# Check if git is not installed
if  ! git="$(type -p git)" || [[ -z $git ]]; then
  apt-get install git -y
fi

# add usefull git alias
git config --global alias.up '!git remote update -p; git merge --ff-only @{u}'

# Check if logcheck is not installed
if ! logcheck="$(type -p logcheck)" || [[ -z $logcheck ]]; then
  apt-get install logcheck -y
fi

# Clone Malilog if needed
if [ ! -d "Malilog" ]; then
  git clone https://github.com/Projet-SIEM/Malilog.git
fi

cd Malilog
# Update Malilog if needed
git checkout master && git up;
cd .. && ls
