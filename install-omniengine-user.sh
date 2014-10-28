#!/bin/sh
set -x
#REPOURL="https://github.com/mastercoin-MSC/omniEngine.git"
#BRANCH="master"
REPOURL=$1
BRANCH=$2
REPODIR="omniEngine"
BTCRPC_CONNECT=$3
BTCRPC_USER=$4
BTCRPC_PASSWORD=$5
BTCRPC_SSL=$6
PGHOST=$7
PGUSER=$8
PGPASSWORD=$9
PGPORT=$10


# Install RPMs, python packages, etc.
cd /vagrant
./install-prerequisites.sh
cd 

# Clone and checkout using passed (usually from Vagrant) parameters
git clone --no-checkout $REPOURL $REPODIR
cd $REPODIR
git checkout $BRANCH

mkdir -p logs

mkdir -p ~/.omni
mkdir -p ~/.bitcoin

#cp /vagrant/bitcoin.conf ~/.bitcoin/bitcoin.conf
#cp /vagrant/sql.conf ~/.omni
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

python install/installOmniEngineCronJob.py


