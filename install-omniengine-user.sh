#!/bin/sh
#REPOURL="https://github.com/mastercoin-MSC/omniEngine.git"
#BRANCH="master"
REPOURL="https://github.com/msgilligan/omniEngine.git"
BRANCH="msgilligan-vagrant"
REPODIR="omniEngine"

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

cp /vagrant/bitcoin.conf ~/.bitcoin/bitcoin.conf
cp /vagrant/sql.conf ~/.omni

python install/installOmniEngineCronJob.py


