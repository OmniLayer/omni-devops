# Omniwallet, OmniEngine, and Master Core Devops
 
Deployment and management scripts for the new Master Core-based Omniwallet.

Omniwallet consists of 4 main components/servers. The *Vagrantfile* in this repository contains VM configurations for 3 of these components. We are currently focused on using [Amazon RDS](http://aws.amazon.com/rds/postgresql/) for the PostgreSQL server component, but PostgreSQL could be run from a Vagrant VM or any PostgreSQL server host.

1. Master Core RPC Server: `mastercore` VM
1. PostgreSQL Database Server: PostgreSQL or Amazon RDS
1. OmniEngine Server: `omniengine` VM
1. Omniwallet Server: `omniwallet` VM (in progress, be prepared to help debug)

Although it should be possible to deploy all four servers in a single virtual (or physical) machine, it is recommended to use four seprate VMs and these scripts are currently designed to build and deploy 4 separate VMs.

## Prerequisites

* Virtual Box 4.3.10 or later
* Vagrant 1.6.2 or later

Vagrant is available for Mac OS X, Windows, and  Linux. In addition to VirtualBox, Vagrant may be used to provision VMWare, AWS and other virtual environments.

## Recommended/Optional tools

* [Bash](http://www.gnu.org/software/bash/) command-line shell
* [PostgreSQL](http://www.postgresql.org/download/) command line client tools
* [Java JDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
* [Groovy language](http://beta.groovy-lang.org/download.html)
* Amazon [EC2 CLI Tools](http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/ec2-cli-get-set-up.html)
* Amazon [RDS Command Line Tools](http://docs.aws.amazon.com/AmazonRDS/latest/CommandLineReference/StartCLI.html)

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

The instructions for setting up the various servers show the `--provider=aws` option enclosed in square brackets `[` `]` which indicates that it is an optional option. If used, the `--provider=aws` option requires that Vagrant have support for AWS installed and a AWS base box named "omni-aws" created. (If the option is not specified, Vagrant will use VirtualBox on your local system, in which case you can skip this section.) 

1. Install the Vagrant AWS plugins

        $ vagrant plugin install vagrant-aws
        $ vagrant plugin install vagrant-awsinfo

1. Create the Omni AWS Vagrant Base Box

        $ cd omni-devops
        $ vagrant box add omni-aws tools/omni-aws.box

## Master Core RPC Server Setup

VM name `mastercore`

1. Copy `DefaultVagrantConfig.rb` to `LocalVagrantConfig.rb` and make sure `LocalVagrantConfig.rb` contains the correct values for Master Core RPC setup. For the `mastercore` VM you'll need to set the AWS variables (starting with `AWS_`, except `AWS_CREDENTIAL_FILE`), the `OMNIENGINE_GIT_REPO` and `OMNIENGINE_GIT_BRANCH` setting to specify where to fetch the source to build from, and the `BTCRPC_` variables (except `BTCRPC_CONNECT` which isn't needed to create the `mastercore` VM, but to access it). 

1. Make sure `mastercore-synced/openssl.cnf` has the values you want for your self-signed SSL certificate.

1. Create and boot a VM with Vagrant and install Master Core

        $ vagrant up mastercore [--provider=aws]

The Master Core daemon is now running as an Ubuntu service and will be automatically restarted upon system reboots as well as if the daemon crashes.

1. If you have not done so already set the `BTCRPC_CONNECT` variable in `LocalVagrantConfig.rb` to the hostname or IP address of the `mastercore` VM that you just created.

## PostgreSQL Database Server Setup

Although [PostgreSQL](http://www.postgresql.org) may be run in a general purpose VM, development at the Mastercoin Foundation has been focused upon using the [RDS database service](http://aws.amazon.com/rds/postgresql/) provided by Amazon.

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

VM name `omniengine`

1. Copy `DefaultVagrantConfig.rb` to `LocalVagrantConfig.rb` and make sure `LocalVagrantConfig.rb` contains the correct host, username, and password values for the PostgreSQL and Master Core RPC servers.

1. Create and boot a VM with Vagrant and install and run OmniEngine

        $ vagrant up omniengine [--provider=aws]

## Omniwallet Server Setup

VM name `omniwallet`

NOTE: THE OMNIWALLET VM INSTALL IS PRE-ALPHA. It is now working, BUT HAS HAD MINIMAL TESTING. Please give it a try.

FEEDBACK AND/OR PULL REQUESTS WELCOME.

1. Copy `DefaultVagrantConfig.rb` to `LocalVagrantConfig.rb` and make sure `LocalVagrantConfig.rb` contins the correct host, username, and password values for the PostgreSQL and Master Core RPC servers.

1. Create and boot a VM with Vagrant and install and Omniwallet

        $ vagrant up omniwallet [--provider=aws]

1. Connect to the `omniwallet` VM

        $ vagrant ssh omniwallet

1. Make sure `nginx` is running:

        $ sudo service nginx status

1. Set an environment variable containing a secret passphrase. It is used to generate salts for individual user IDs, and it needs to be both secret AND not change.

        export OMNIWALLET_SECRET="DontTellAnyoneThis"

1. Configure an email server for sending account information.

1. Launch the wrapper (do *NOT* use `sudo`)

        $ cd omniwallet
        $ mkdir -p logs
        $ ./app.sh &> logs/appsh.log &

1. Use your browser to go to the correct port on the newly installed VM. You should see Omniwallet running there.


## Troubleshooting Tips

### Vagrant/VirtualBox

1. Make sure that Vagrant (and VirtualBox) are installed correctly. You can use the `empty` VM provided in the *Vagrantfile* to quickly test that Vagrant is working correctly. The empty VM does not contain any Master Core or Omni services but offers a quick test that Vagrant and the supporting "provider" are working and configured correctly.

        $ vagrant up empty [--provider=aws]

1. If you're running Vagrant from Microsoft Windows make sure that the text files you checked out with Git have UNIX line seperators not MS-DOS/Winodws CRLF line seperators. If you get an error message which complains about `\r` characters, check your Git configuration. The [`.gitattributes`](https://github.com/mastercoin-MSC/omni-devops/blob/master/.gitattributes) file in this repository is now configured to ensure that even on Windows, text files have lines separated by LF, not CRLF.

1. If you're using Virtualbox on Windows and your Windows host is becoming unresponsive, you can try uncommenting the following line in `Vagrantfile`:

        v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"] #limit the use of cpu to 50%

1. You can also reduce the number of CPUs used for a particular Virtualbox VM which may also help to reduce load on your host system. The configuration lines in `Vagrantfile` that you are interested in look like this:

        v.cpus = 2

1. If you're on Windows 8.1, don't use the `vagrant suspend` command because of this [VirtualBox bug](https://www.virtualbox.org/ticket/13583). (There's also a [Vagrant Issue](https://github.com/mitchellh/vagrant/issues/4276) with more specific information and some workarounds.)
        
### Master Core VM

1. Make sure you didn't skip the step to assign an RPC username and password.



