#!/bin/sh

# Standard AWS Settings
export AWS_ACCESS_KEY="access"
export AWS_SECRET_KEY="key"
export AWS_KEYPAIR_NAME="name"
export AWS_SSH_KEY_PATH="/path/to/file.pem"
export AWS_DEFAULT_REGION="us-west-2"
export AWS_CREDENTIAL_FILE="/path/to/credentials.txt"

# RDS command line tools use EC2_REGION
export EC2_REGION=$AWS_DEFAULT_REGION

# Standard PostgreSQL Settings
export PGUSER="user"
export PGPASSWORD="pass"
export PGPORT=5432

# Omni Settings
export OMNI_DB_INSTANCE="instance-name"
export OMNI_DB_SEC_GID="groupid"

# Bitcoind/Mastercored settings
export BTCRPC_CONNECT="127.0.0.1"
export BTCRPC_USER="bitcoinrpcuser"
export BTCRPC_PASSWORD="pass"
export BTCRPC_SSL=1




