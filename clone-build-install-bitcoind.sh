#!/bin/bash
REPOURL=$1
BRANCH=$2
REPODIR=$3
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
 



