#
# DefaultVagrantConfig.rb
#
# This file is required by the omni-devops Vagrantfile to initialize settings
#
# DO NOT CHANGE THIS FILE DIRECTLY!
#
# To Override settings copy to LocalVagrantConfig.rb and modify variables as needed
#

#
# Default region for creating EC2 VMs, etc.
#
AWS_DEFAULT_REGION="us-west-2"

#
# Configure Git Repository and Branch for Omniwallet
#
OMNIWALLET_GIT_REPO="https://github.com/mastercoin-MSC/omniwallet.git"
OMNIWALLET_GIT_BRANCH="master"

#
# Configure Git Repository and Branch for OmniEngine
#
OMNIENGINE_GIT_REPO="https://github.com/mastercoin-MSC/omniEngine.git"
OMNIENGINE_GIT_BRANCH="master"

#
# Configure Git Repository and Branch for Master Core build from source
#
MASTERCORE_GIT_REPO="https://github.com/msgilligan/mastercore.git"
MASTERCORE_GIT_BRANCH="msgilligan-msc-upstart"

# Standard PostgreSQL Settings
PGUSER="setme"
PGPASSWORD="setme"
PGHOST="setme"
PGPORT="5432"

# Bitcoind/Mastercored settings
BTCRPC_CONNECT="setme"
BTCRPC_USER="setme"
BTCRPC_PASSWORD="setme"
BTCRPC_SSL="1"



