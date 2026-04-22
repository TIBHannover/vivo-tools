#!/bin/bash
set -x #echo on
sudo echo "$(basename "$0")"

sudo apt install git -y

./1java.sh
./2tomcat.sh
./3solr.sh
./4vivo.sh
