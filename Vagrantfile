# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Specify minimum Vagrant version
Vagrant.require_version ">= 1.6.2"

LOCAL_CONFIG_RB="#{File.dirname(__FILE__)}/LocalVagrantConfig.rb";
DEFAULT_CONFIG_RB="#{File.dirname(__FILE__)}/DefaultVagrantConfig.rb";
if File.exist?(LOCAL_CONFIG_RB)
#  puts "Loading local config from #{LOCAL_CONFIG_RB}"
  require LOCAL_CONFIG_RB
else
#  puts "Loading default config from #{DEFAULT_CONFIG_RB}"
  require DEFAULT_CONFIG_RB
end

#puts "Amazon region is: #{AWS_DEFAULT_REGION}"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.boot_timeout = 720
  # Every Vagrant virtual environment requires a box to build off of.
  # Version 0.2.0 is Ubuntu 14.04 LTS built from "ubuntu/trusty64"
  config.vm.box = "msgilligan/mastercoin-ubuntu-base"
  config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", disabled: true
  config.vm.synced_folder "synced", "/vagrant", id: "vagrant-synced", disabled: false

  config.vm.provider "virtualbox" do |v|
    v.memory = 3840   # 3.75 GB, same as Amazon m3.medium
    v.cpus = 4
    #v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"] #limit the use of cpu to 50%
  end

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV['AWS_ACCESS_KEY'] || ""
    aws.secret_access_key = ENV['AWS_SECRET_KEY'] || ""
    aws.keypair_name = ENV['AWS_KEYPAIR_NAME'] || ""

    aws.region = AWS_DEFAULT_REGION
    aws.instance_type = "m3.medium"
    aws.security_groups =  [ 'web' ]

# ubuntu/images/ebs/ubuntu-trusty-14.04-amd64-server-20140607.1 - ami-f34032c3
# ebs, paravirtualization, 64-bit
# uswest-2
#    aws.ami = "ami-f34032c3" # uswest-2
#    aws.ami = "ami-a26265e7" # uswest-1
    aws.ami = "ami-d34032e3"    # uswest-2, amd64, type="hvm:ebs"

    aws.block_device_mapping = [{ 'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => 60, 'Ebs.DeleteOnTermination' => false }]

    override.vm.box = "omni-aws"
    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = ENV['AWS_SSH_KEY_PATH'] || ""
  end

#
# base
#
# Configuration for a base Ubuntu VM for Mastercoin
#
# Updated Ubuntu, make, git, libboost, etc
# See install-mastercoin-base-root.sh for details
#
# This VM is published on https://vagrantcloud.com as
# 'msgilligan/mastercoin-ubuntu-base' and used as the
# base box by all other VMs in this Vagrantfile.
# 
  config.vm.define "base", autostart: false do |base|
      base.vm.box = "ubuntu/trusty64"
      base.vm.provision "shell" do |s|
        s.path = "install-mastercoin-base-root.sh"
      end
  end

#
# empty
#
# Configuration for an empty install based on 'base'
#
  config.vm.define "empty", autostart: false  do |empty|
  end


#
# omniwallet
#
# Configuration for Ubuntu VM with Omniwallet
#
# Production is m1.small (do we need that instance storage or should we use a t2 or m3 instance?)
#
  config.vm.define "omniwallet" do |omni|

    omni.vm.network :forwarded_port, host_ip: "127.0.0.1", guest: 80, host: 1666
    omni.vm.synced_folder "omniwallet-synced", "/vagrant", id: "vagrant-synced", disabled: false


    omni.vm.provision "shell", id: "sh-omni-root" do |s|
      s.path = "install-omniwallet-root.sh"
      s.args = [ "vagrant", "vagrant"]                # user, group for /var/lib/omniwallet
    end 

    omni.vm.provider :aws do |aws, override|
      override.vm.provision "shell", id: "sh-omni-root" do |s|
        s.args = [ "ubuntu", "ubuntu"]                # user, group for /var/lib/omniwallet
      end
    end

    omni.vm.provision "shell" do |s|
      s.privileged = false
      s.path = "install-omniwallet-user.sh"
      s.args = [OMNIWALLET_GIT_REPO,            # Git Repo to clone/checkout from
                OMNIWALLET_GIT_BRANCH]          # Branch to check out
    end

    omni.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 2
    end

    omni.vm.provider "aws" do |aws|
      aws.tags = {
        'Name' => 'omniwallet',
        'Type' => 'vagrant-omniwallet'
      }
    end

  end
  

#
# omniengine
#
# Configuration for Ubuntu VM with OmniEngine
#
# Production is t2.micro
#
  config.vm.define "omniengine" do |omni|

    omni.vm.synced_folder "omniengine-synced", "/vagrant", id: "vagrant-synced", disabled: false


    omni.vm.provision "shell" do |s|
        s.privileged = false
        s.path = "install-omniengine-user.sh"
        s.args = [OMNIENGINE_GIT_REPO,    # Repo to clone
                  OMNIENGINE_GIT_BRANCH,  # Branch to checkout 
                  BTCRPC_CONNECT,     # Bitcoin RPC Host
                  BTCRPC_USER,        # Bitcoin RPC username
                  BTCRPC_PASSWORD,    # Bitcoin RPC password
                  BTCRPC_SSL,         # Use SSL for RPC
                  PGHOST,             # Postgres host
                  OMNIDB_ENGINE_USER,     # Postgres username
                  OMNIDB_ENGINE_PASSWORD, # Postgres password
                  PGPORT]             # Postgres port
    end

    omni.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.cpus = 2
    end

    omni.vm.provider "aws" do |aws|
      aws.tags = {
        'Name' => 'omniengine',
        'Type' => 'vagrant-omniengine'
      }
    end

  end


#
# mastercore
#
# Configuration for Master Core deployment
#
# Master Core is currently built from source code.
#
# Production is m3.medium
#
  config.vm.define "mastercore", autostart: false do |mastercore|

    mastercore.vm.synced_folder "mastercore-synced", "/vagrant", id: "vagrant-synced", disabled: false

    mastercore.vm.network :forwarded_port, host_ip: "127.0.0.1", guest: 8332, host: 38332
 
    mastercore.vm.provision "shell" do |s|
      s.path = "install-mastercoin-base-root.sh"
    end

    mastercore.vm.provision "shell" do |s|
        s.privileged = false
        s.path = "clone-build-install-bitcoind.sh"
        s.args = [MASTERCORE_GIT_REPO,                # Git Repo to clone/checkout from
                  MASTERCORE_GIT_BRANCH,              # Branch to check out
                  "mastercore"]                       # Directory to clone into
    end

    mastercore.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.cpus = 8
    end

    mastercore.vm.provider "aws" do |aws|
      aws.tags = {
        'Name' => 'mastercore',
        'Type' => 'vagrant-mastercore'
      }
    end

  end

end
