#!/bin/bash
set -x #echo on
sudo echo "$(basename "$0")"

tomcatDir="/opt/tomcat"

# determine latest Tomcat version
tomcat_url='https://dlcdn.apache.org/tomcat/tomcat-9'
version=$(
  curl --fail --silent --show-error --location "$tomcat_url/" |
  grep -oE 'href="v9\.0\.[0-9]+/"' |
  sed -E 's/.*v(9\.0\.[0-9]+)\/".*/\1/' |
  sort -V |
  tail -n 1
)

[[ -n "$version" ]] || {
  echo "No downloadable version found" >&2
  exit 1
}

# create user
if ! id -u tomcat >/dev/null 2>&1; then
  sudo useradd -r -m -U -d $tomcatDir -s /bin/false tomcat
fi

sudo mkdir -p $tomcatDir
sudo chown tomcat:tomcat $tomcatDir
sudo chmod 777 $tomcatDir

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

# set permissions
sudo chown -R tomcat:tomcat $tomcatDir
sudo chmod 775 -R $tomcatDir

# instructions
echo "sudo usermod -aG tomcat $USER && newgrp tomcat"
echo "sudo systemctl daemon-reload"
echo "sudo systemctl enable --now tomcat"
