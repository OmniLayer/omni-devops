#!/bin/sh
MSC_USER=$(logname) #possibly use this versus passed in args 
MSC_GROUP=$2
mkdir -p /var/lib/omniwallet
chown -R $MSC_USER:$MSC_GROUP /var/lib/omniwallet


