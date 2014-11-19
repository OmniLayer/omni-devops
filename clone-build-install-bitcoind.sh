#!/bin/bash
set -x
REPOURL=$1
BRANCH=$2
REPODIR=$3
BTCRPC_CONNECT=$4
BTCRPC_USER=$5
BTCRPC_PASSWORD=$6
BTCRPC_SSL=$7
BTCRPC_ALLOWIP=$8
USERNAME=`whoami`

# Clone and checkout using passed (usually from Vagrant) parameters
git clone --no-checkout $REPOURL $REPODIR
cd $REPODIR
git checkout $BRANCH

# Build bitcoind (Master Core)

./autogen.sh
./configure
make

# Install as an Upstart service
sudo ./contrib/msc-ubuntu/install-mastercore-upstart.sh

# Put the vagrant user (usually 'vagrant' or 'ubuntu') in the bitcoin group
# so that /etc/bitcoin/bitcoin.conf can be seen by bitcoin-cli/mastercore-cli
sudo usermod -a -G bitcoin $USERNAME

if [ $BTCRPC_SSL == "1" ] ; then
    echo "Creating self-signed SSL certificate..."
    cd /var/lib/bitcoind
    sudo openssl genrsa -out server.pem 2048
    sudo openssl req -new -x509 -nodes -sha1 -days 3650 -key server.pem -batch -config /vagrant/openssl.cnf -out server.cert
fi

sed -e "s#^.\(rpcuser=\)\(.*\)#\1${BTCRPC_USER}#" \
    -e "s#^.\(rpcpassword=\)\(.*\)#\1${BTCRPC_PASSWORD}#" \
    -e "s#^.\(rpcssl=\)\(.*\)#\1${BTCRPC_SSL}#" \
    -e "s#^.\(rpcallowip=\)\(.*\)#\1${BTCRPC_ALLOWIP}#" \
    /etc/bitcoin/bitcoin-msc-template.conf >  /etc/bitcoin/bitcoin.conf

sudo service mastercored start
