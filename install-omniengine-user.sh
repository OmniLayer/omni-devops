#!/bin/sh
REPOURL="https://github.com/mastercoin-MSC/omniEngine.git"
BRANCH="master"
REPODIR="omniEngine"

# Clone and checkout using passed (usually from Vagrant) parameters
git clone --no-checkout $REPOURL $REPODIR
cd $REPODIR
git checkout $BRANCH

mkdir -p ~/.omni
mkdir -p ~/.bitcoin

cp /vagrant/bitcoin.conf ~/.bitcoin/bitcoin.conf
cp /vagrant/sql.conf ~/.omni




