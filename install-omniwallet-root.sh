#!/bin/sh
MSC_USER=$(logname) #possibly use this versus passed in args 
MSC_GROUP=$2
echo "Running install-sx..."
cd /vagrant/res
#Disable installing SX
#bash install-sx.sh

mkdir -p /var/lib/omniwallet
chown -R $MSC_USER:$MSC_GROUP /var/lib/omniwallet


