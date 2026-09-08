#!/bin/bash
set -x #echo on
sudo echo "$(basename "$0")"

solrDir="/opt/solr"
vivoSolrBranch="solr-8.11"

# determine latest version
versionUrl="https://archive.apache.org/dist/lucene/solr"
version=$(
  curl -fsSL "$versionUrl/" |
    sed -nE 's#.*href="(8\.11\.[0-9]+)/?".*#\1#p' |
    sort -V |
    tail -n 1
)

if [ -z "$version" ]; then
  echo "No downloadable version found" >&2
  exit 1
fi

sudo mkdir $solrDir
sudo chown tomcat:tomcat $solrDir
sudo chmod 777 $solrDir

cd $solrDir || exit

# solr
wget https://archive.apache.org/dist/lucene/solr/${version}/solr-${version}.tgz
tar xzvf solr-${version}.tgz -C . --strip-components=1

# vivo-solr
git clone https://github.com/vivo-project/vivo-solr vivo-solr -b $vivoSolrBranch
cp -a vivo-solr/vivocore $solrDir/server/solr/vivocore

# set permissions
sudo chown -R tomcat:tomcat $solrDir
sudo chmod 775 -R $solrDir

# instructions
echo "sudo -u tomcat ${solrDir}/bin/solr start"
echo "${solrDir}/bin/solr stop"
