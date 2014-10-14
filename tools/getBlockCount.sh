#!/bin/sh
bitcoin-cli -rpcconnect=$BTCRPC_CONNECT -rpcssl -rpcuser=$BTCRPC_USER -rpcpassword="$BTCRPC_PASSWORD" getblockcount
