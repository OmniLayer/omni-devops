#!/bin/bash
#Tested on Ubuntu 14.04 LTS
#set -e
set -e -x
REPOURL=$1
BRANCH=$2

#Set some Variables
NAME=`logname`
PIPFILELOC="/home/$NAME/omniwallet"

if [ ! -f ~/.ssh/id_rsa.pub ]; then
	SSHGEN=
	while [ -z "$SSHGEN" ]; do
		echo "Public ssh key not found in ~/.ssh/id_rsa"
		echo "Do you wish to generate one now?[y/n]"
		SSHGEN='n'
	done
	case $SSHGEN in

        y* | Y* )
		echo "Generating ~/.ssh/id_rsa:"
		echo n | sudo -u $NAME ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""
        ;;
	*)
                echo "Slipping new ssh key generation"
        ;;
        esac
fi

echo "#############################"
echo "Adding your SSH key to Github"
echo "Before Continuing please follow Steps 3 and 4 of the Github SSH key guide"
echo "https://help.github.com/articles/generating-ssh-keys"
echo ""
echo "Your SSH key from ~/.ssh/id_rsa.pub is:"
echo "----------------------------------------------------------------------------------"
#cat ~/.ssh/id_rsa.pub
echo "----------------------------------------------------------------------------------"
echo ""
echo "#############################"

SSH="sudo -s -u $NAME ssh -o StrictHostKeyChecking=no -T -q git@github.com"

VALID=0 # do not run
while [ $VALID -ne 0 ]; do
        echo "When You have updated Github please enter exactly:"
	echo "		SSH Key Updated"
        read SSHREP
	if [[ $SSHREP == "SSH Key Updated" ]]; then
		sshout=`${SSH} > /dev/null 2>&1 || echo $?`
		if [[ $sshout -eq 1 ]]; then
			echo "SSH Key Matched: Proceeding"
			VALID=0
		else
			echo "Something didn't work, check your key and try again"
			SSHREP="Nope"
		fi
	fi
done

# do this before starting
sudo apt-get autoremove
# Make sure we're getting the newest packages.
sudo apt-get update
#Make sure we have python and build tools
sudo apt-get -y install python-software-properties python
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo add-apt-repository -y ppa:nginx/stable
sudo apt-get update

# If this is a local image, you may need sshd set up.
sudo apt-get -y install openssh-server openssh-client
 
# Install some system stuff
sudo apt-get -y install daemontools

# Get your tools together
sudo apt-get -y install vim git curl libssl-dev make

# Stuff so you can compile
sudo apt-get -y install gcc g++ lib32z1-dev pkg-config ant
sudo apt-get -y install ruby 
echo "installing sass..."
sudo gem install sass
echo "done."
sudo apt-get -y install python-dev python-setuptools

#Special node.js installation from chris-lea repository
sudo apt-get -y install nodejs

# Get forever, install globally
sudo npm install -g forever

# Make it so that grunt can be used
sudo npm install -g grunt-cli

# Other node-based compilation tools
sudo npm install -g less
sudo npm install -g jshint

#Get/clone Omniwallet - might be relevant
echo "cloning omniwallet into $HOME"
cd $HOME
git clone --no-checkout $REPOURL omniwallet
cd omniwallet
git checkout $BRANCH
cd $HOME

# May need to clean up some strange permissions from the npm install.
sudo chown -R $NAME:$NAME ~/.npm
#sudo chown -R $NAME:$NAME ~/tmp

#install packages:
sudo apt-get -y install python-simplejson python-git python-pip libffi-dev
sudo apt-get -y install build-essential autoconf libtool libboost-all-dev pkg-config libcurl4-openssl-dev libleveldb-dev libzmq-dev libconfig++-dev libncurses5-dev libpq-dev

#sx install is run earlier

#Pip requirements
#sudo pip install -r $SRC/pip.packages
sudo pip install -r $PIPFILELOC/requirements.txt

#fix for incompleteread bug
sudo rm -rf /usr/local/lib/python2.7/dist-packages/requests
sudo pip install requests

#Get and setup nginx
sudo apt-get -y install uwsgi uwsgi-plugin-python
sudo apt-get -y install nginx

sed -i "s/myUser/$NAME/g" ~/omniwallet/etc/nginx/sites-available/default
sed -i "s/\/var\/lib\/omniwallet\/www\/values.json/\/home\/$NAME\/omniwallet\/var\/lib\/omniwallet\/www\/values.json/g" ~/omniwallet/etc/nginx/sites-available/default

#Update nginx conf with omniwallet specifics
sudo cp ~/omniwallet/etc/nginx/sites-available/default /etc/nginx/sites-available

sudo npm install -g uglify-js

#Start the omniwallet dependency setup
sudo chown -R $NAME:$NAME ~/omniwallet
cd ~/omniwallet
sudo -u $NAME npm install
sudo -u $NAME sudo npm install bower -g
sudo -u $NAME grunt

#Create omniwallet data directory 
sudo mkdir -p /var/lib/omniwallet
sudo chown -R $NAME:$NAME /var/lib/omniwallet

#start the web interface
sudo nginx -s stop
sudo nginx

set +x
echo ""
echo "Installation complete"
echo "Omniwallet should have been downloaded/installed in "$PWD
echo "Omniwallet will be accessible at port 80 after running ./app.sh in ~/omniwallet/"
echo "(If you're using Vagrant/Virtualbox port 80 in this VM is typically mapped to localhost:1666)"
echo ""
echo ""
echo "The webinterface is handled by nginx"
echo "'sudo service nginx [stop/start/restart/status]'"
echo ""
echo "There is a wrapper app.sh which runs Omniwallet."
echo ""
echo ""
echo "----------------Run Commands------------------"
echo "Start a new screen session with: screen -S omni"
echo "cd "$PWD
echo "Set an environment variable containing a secret passphrase - this is used to generate salts for indivdual"
echo "user IDs, and it needs to be both secret AND not change."
echo ""
echo "  export OMNIWALLET_SECRET=\"DontTellAnyoneThis\""
echo ""
echo "launch the wrapper:  ./app.sh"
echo "Note: Do NOT launch it with sudo"
echo "You can disconnect from the screen session with '<ctrl-a> d'"
echo "You can reconnect to the screen session with 'screen -r omni'"
echo "----------------------------------"
