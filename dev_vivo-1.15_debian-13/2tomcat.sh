#!/bin/bash
set -x #echo on
sudo echo "$(basename "$0")"

version="9.0.117"
tomcatDir="/opt/tomcat"

sudo mkdir -p $tomcatDir
sudo chmod 777 -R $tomcatDir
cd $tomcatDir || exit

wget "https://dlcdn.apache.org/tomcat/tomcat-9/v${version}/bin/apache-tomcat-${version}.tar.gz"
tar xzvf "apache-tomcat-${version}.tar.gz" -C . --strip-components=1

# create systemd system file
sudo tee /etc/systemd/system/tomcat.service > /dev/null <<EOF
[Unit]
Description=Apache Tomcat 9
After=network.target

[Service]
Type=oneshot
ExecStart=${tomcatDir}/bin/startup.sh
ExecStop=${tomcatDir}/bin/shutdown.sh
RemainAfterExit=yes
User=tomcat
Group=tomcat

[Install]
WantedBy=multi-user.target
EOF

# create user
sudo useradd -r -m -U -d $tomcatDir -s /bin/false tomcat

# set permissions
sudo chown -R tomcat:tomcat $tomcatDir
sudo chmod 777 -R $tomcatDir
sudo chmod +x $tomcatDir/bin/startup.sh
sudo chmod +x $tomcatDir/bin/shutdown.sh

# instructions
echo "sudo systemctl daemon-reload"
echo "sudo systemctl enable --now tomcat"
