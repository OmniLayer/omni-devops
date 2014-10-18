#!/bin/bash
# Vagrant install script run as 'vagrant' user -- not sudo
echo "Running 'vagrant' user portion of install..."
cd /vagrant
echo "tcp://obelisk.bysh.me:9091" > $HOME/.sx.cfg
# Add $REPO $BRANCH arguments after we strip out all the interactive stuff for handling/prompting
# for SX server config
#bash install-omni.sh -os $REPO $BRANCH
bash install-omni.sh
