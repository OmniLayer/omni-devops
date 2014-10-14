# Omniwallet, OmniEngine, and Master Core Devops
 
Deployment and management scripts for the new OmniEngine-based Omniwallet.

Omniwallet consists of 4 main components/servers:

1. Master Core RPC Server
1. PostgreSQL Database Server
1. OmniEngine Server
1. Omniwallet Server

Although it is possible to deploy all four servers in a single virtual (or physical) machine, it is recommended to use four seprate VMs and these scripts are currently designed to build and deploy 4 separate VMs.

## Prerequisites

* Virtual Box 4.3.10 or later
* Vagrant 1.6.2 or later

Vagrant is available for Mac OS X, Windows, and  Linux. In addition to VirtualBox, Vagrant may be used to provision VMWare, AWS and other virtual environments.

### Base Box

The [Vagrantfile](Vagrantfile) is currently using (*trusting*) the [ubuntu/trusty64](https://vagrantcloud.com/ubuntu/trusty64) base box created by Ubuntu and the Mastercoin base box [msgilligan/mastercoin-ubuntu-base](https://vagrantcloud.com/msgilligan/mastercoin-ubuntu-base).

You should consider them untrusted binaries. Only use them with TEST-MSC and small amounts of Bitcoin.

## Installing Prerequisites

1. [Install VirtualBox](https://www.virtualbox.org/manual/ch02.html)
1. [Install Vagrant](http://docs.vagrantup.com/v2/installation/)
1. Clone this repository and check out the 'master' branch

        $ git clone git@github.com:mastercoin-MSC/omni-devops.git
        $ cd omni-devops

## Installing support for AWS

The instructions for setting up the various servers include the `--provider=aws` option which require that Vagrant have support for AWS installed and a AWS base box named "omni-aws" created. (It is possible to use Vagrant with VirtualBox, in which case you can skip this section and ommit the `--provider=aws` argument) 

1. Install the Vagrant AWS plugins

        $ vagrant plugin install vagrant-aws
        $ vagrant plugin install vagrant-awsinfo

1. Create the Omni AWS Vagrant Base Box

        $ cd omni-devops
        $ vagrant box add omni-aws tools/omni-aws.box

## Master Core RPC Server Setup

1. Create and boot a VM with Vagrant and install Master Core

        $ vagrant up mastercore --provider=aws

1. Connect to the VirtualBox VM

        $ vagrant ssh mastercore

1. Open the `bitcoin.conf` with an editor, e.g.

        $ vi /etc/bitcoin/bitcoin.conf

1. Make sure the following configuration options in `bitcoin.conf` are set correctly: `rpcuser`, `rpcpassword`, `rpcallowip`, `rpcssl`.

1. Start the Master Core daemon:

         $ sudo service mastercored start

1. Record the `rpcuser`, `rpcpassword` values as well as the IP address of the server for use in OmniEngine configuration.

The Master Core daemon is now running as an Ubuntu service and will be automatically restarted upon system reboots as well as if the daemon crashes.

## PostgreSQL Database Server Setup

Althought [PostgreSQL](http://www.postgresql.org) may be run in a general purpose VM, development at the Mastercoin Foundation has been focused upon using the [RDS database service](http://aws.amazon.com/rds/postgresql/) provided by Amazon.

To create your own PostgreSQL instance using Amazon RDS, follow these steps:

1. Make sure you have the AWS EC2 Tools and AWS RDS Tools installed corectly.

1. Make sure you have the Groovy language installed correctly.

1. Copy the environment setup template file.

        $ cp setup-omni-template.sh setup-omni-private.sh
        $ chmod 700 setup-omni-private.sh

1. Edit `setup-omni-private.sh` and make sure to set (at least) the following variables: `AWS_ACCESS_KEY`, `AWS_SECRET_KEY`, `AWS_CREDENTIAL_FILE`, `PGUSER`, `PGPASSWORD`, `OMNI_DB_INSTANCE`, `OMNI_DB_SEC_GID`

1. Run the following commands:

        $ source setup-omni-private.sh
        $ cd rds
        $ ./create-omnidb-instance.sh
        $ ./waitForDBAvailable.groovy

1. Use the `./list-rds-instances.sh` command to find the hostname of the RDS instance

## OmniEngine Server Setup

1. Edit `omniengine-synced/bitcoin.conf` and `omniengine-synced/sql.conf` to contain the correct host, username, and password values for the DB and Master Core RPC servers.

1. Create and boot a VM with Vagrant and install and run OmniEngine

        $ vagrant up omniengine --provider=aws

## Omniwallet Server Setup

To be written.






