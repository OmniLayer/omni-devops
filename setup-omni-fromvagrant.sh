#!/bin/sh

# Ruby script that is also valid BASh
source LocalVagrantConfig.rb

# Standard AWS Settings
export AWS_ACCESS_KEY
export AWS_SECRET_KEY
export AWS_KEYPAIR_NAME
export AWS_SSH_KEY_PATH
export AWS_DEFAULT_REGION
export AWS_CREDENTIAL_FILE

# RDS command line tools use EC2_REGION
export EC2_REGION=$AWS_DEFAULT_REGION

# Standard PostgreSQL Settings
export PGUSER
export PGPASSWORD
export PGHOST
export PGPORT

export OMNIDB_ENGINE_USER
export OMNIDB_ENGINE_PASSWORD
export OMNIDB_WWW_USER
export OMNIDB_WWW_PASSWORD

# Bitcoind/Mastercored settings
export BTCRPC_CONNECT
export BTCRPC_USER
export BTCRPC_PASSWORD
export BTCRPC_SSL




