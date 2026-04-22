#!/bin/bash
set -x #echo on
sudo echo "$(basename "$0")"

echo 'deb http://deb.debian.org/debian unstable main non-free contrib' | sudo tee -a /etc/apt/sources.list > /dev/null

sudo apt update

sudo apt install openjdk-11-jdk -y

sudo apt install maven -y
