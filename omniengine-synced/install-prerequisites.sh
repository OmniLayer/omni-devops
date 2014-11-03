#!/bin/bash

sudo apt-get update

#install packages (from MSC Tools):
sudo apt-get -y install python-simplejson python-git python-pip
sudo apt-get -y install git curl p7zip-full make
sudo apt-get -y install build-essential autoconf libtool libboost-all-dev pkg-config libcurl4-openssl-dev libleveldb-dev libzmq-dev libconfig++-dev libncurses5-dev

#install packages for OmniEngine DB client
sudo apt-get -y install postgresql-client-9.3 libpq-dev

#install PHP pacakges
sudo pip install -r pip.packages

