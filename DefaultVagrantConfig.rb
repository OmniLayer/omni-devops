#
# DefaultVagrantConfig.rb
#
# This file is required by the omni-devops Vagrantfile to initialize settings
#
# DO NOT CHANGE THIS FILE DIRECTLY!
#
# To Override settings copy to LocalVagrantConfig.rb and modify variables as needed
#

# Standard AWS Settings
AWS_ACCESS_KEY="setme"
AWS_SECRET_KEY="setme"
AWS_KEYPAIR_NAME="setme"
AWS_SSH_KEY_PATH="/path/to/key.pem"
AWS_DEFAULT_REGION="us-west-2"
AWS_CREDENTIAL_FILE="/path/to/rds-credentials.txt"

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

# Username/Password for 'omniengine' and 'omniwww' database users
OMNIDB_ENGINE_USER="omniengine"
OMNIDB_ENGINE_PASSWORD="setme"
OMNIDB_WWW_USER="omniwww"
OMNIDB_WWW_PASSWORD="setme"

# Bitcoind/Mastercored settings
BTCRPC_CONNECT="setme"
BTCRPC_USER="setme"
BTCRPC_PASSWORD="setme"
BTCRPC_SSL="1"



