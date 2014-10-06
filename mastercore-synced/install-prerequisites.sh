#!/bin/bash

#Repositories for bitcoind/mastercore
sudo add-apt-repository ppa:bitcoin/bitcoin

sudo apt-get update

#install packages (from MSC Tools):
sudo apt-get -y install python-simplejson python-git python-pip
sudo apt-get -y install git curl p7zip-full make
sudo apt-get -y install build-essential autoconf libtool libboost-all-dev pkg-config libcurl4-openssl-dev libleveldb-dev libzmq-dev libconfig++-dev libncurses5-dev
sudo pip install -r pip.packages

# bitcoind/mastercore dependencies
sudo apt-get -y install libssl-dev
sudo apt-get -y install software-properties-common
sudo apt-get -y install libdb4.8-dev libdb4.8++-dev
sudo apt-get -y install libprotobuf-dev protobuf-compiler 
