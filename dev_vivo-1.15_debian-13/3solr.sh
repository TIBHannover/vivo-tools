#!/bin/bash
set -x #echo on
sudo echo "$(basename "$0")"

version="8.11.1"
solrDir="/opt/solr"
vivoSolrBranch="solr-8.11"

sudo mkdir $solrDir
sudo chmod 777 -R $solrDir
cd $solrDir || exit

# solr
wget https://archive.apache.org/dist/lucene/solr/${version}/solr-${version}.tgz
tar xzvf solr-${version}.tgz -C . --strip-components=1

# vivo-solr
git clone https://github.com/vivo-project/vivo-solr vivo-solr -b $vivoSolrBranch
cp -a vivo-solr/vivocore $solrDir/server/solr/vivocore

# instructions
echo "${solrDir}/bin/solr start"
