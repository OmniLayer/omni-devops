#!/bin/bash
# Vagrant install script run as vagrant user (usually 'vagrant' or 'ubuntu') -- not sudo
set -e -x
echo "Running 'vagrant' user portion of install..."
REPOURL=$1
BRANCH=$2
BTCRPC_CONNECT=$3
BTCRPC_USER=$4
BTCRPC_PASSWORD=$5
BTCRPC_SSL=$6
PGHOST=$7
PGUSER=$8
PGPASSWORD=$9
PGPORT=${10}

cd /vagrant
bash install-omni.sh $REPOURL $BRANCH

mkdir -p ~/.omni
mkdir -p ~/.bitcoin

sed -e "s#^\(rpcuser=\)\(.*\)#\1${BTCRPC_USER}#" \
    -e "s#^\(rpcpassword=\)\(.*\)#\1${BTCRPC_PASSWORD}#" \
    -e "s#^\(rpcconnect=\)\(.*\)#\1${BTCRPC_CONNECT}#" \
    -e "s#^\(rpcssl=\)\(.*\)#\1${BTCRPC_SSL}#" \
    /vagrant/bitcoin.conf > ~/.bitcoin/bitcoin.conf

sed -e "s#^\(sqluser=\)\(.*\)#\1${PGUSER}#" \
    -e "s#^\(sqlpassword=\)\(.*\)#\1${PGPASSWORD}#" \
    -e "s#^\(sqlconnect=\)\(.*\)#\1${PGHOST}#" \
    -e "s#^\(sqlport=\)\(.*\)#\1${PGPORT}#" \
    /vagrant/sql.conf > ~/.omni/sql.conf
