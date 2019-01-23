#!/bin/bash

# Check if git is not installed
if  ! git="$(type -p git)" || [[ -z $git ]]; then
  apt-get install git -y
fi

# Clone Malilog if needed
if [ ! -d "Malilog" ]; then
  git clone https://github.com/Projet-SIEM/Malilog.git
  ls
fi

ls
