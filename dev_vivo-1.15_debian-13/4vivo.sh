#!/bin/bash
set -x #echo on
sudo echo "$(basename "$0")"

branch="rel-1.15-maint"
appName="vivo-1.15"
appDir="/opt/${appName}"
settingsFile="/opt/${appName}/VIVO/installer/example-settings.xml"
tomcatDir="/opt/tomcat"

sudo mkdir $appDir
sudo chmod 777 -R $appDir
cd $appDir || exit

git clone https://github.com/vivo-project/Vitro.git Vitro -b $branch
git clone https://github.com/vivo-project/VIVO.git VIVO -b $branch

sed -i "s#<app-name>vivo</app-name>#<app-name>${appName}</app-name>#g" $settingsFile
sed -i "s#<vivo-dir>/usr/local/vivo/home</vivo-dir>#<vivo-dir>/opt/${appName}/VIVO/home</vivo-dir>#g" $settingsFile
sed -i "s#<tomcat-dir>/usr/local/tomcat</tomcat-dir>#<tomcat-dir>${tomcatDir}</tomcat-dir>#g" $settingsFile

cp home/config/example.runtime.properties home/config/runtime.properties
cp home/config/example.applicationSetup.n3 home/config/applicationSetup.n3

mvn install -s VIVO/installer/example-settings.xml

# set permissions
sudo chown -R tomcat:tomcat $appDir
sudo chmod 777 -R $appDir
sudo chown -R tomcat:tomcat tomcatDir
sudo chmod 777 -R tomcatDir

# instructions
echo "sudo systemctl restart tomcat"
echo "vivo_root@mydomain.edu"
echo "rootPassword"
