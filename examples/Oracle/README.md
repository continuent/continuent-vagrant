# Installation

    $ localhost> cd ~
    $ localhost> git clone git@github.com:continuent/continuent-vagrant.git oracle
    $ localhost> cd ~/oracle
    $ localhost> git submodule update --init
    $ localhost> cp examples/Oracle/default.pp ./manifests
    $ localhost> cp examples/Vagrantfile.3.vbox ./Vagrantfile
    
Download [Oracle 11g Database Installer](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/112010-linx8664soft-100572.html) to ./downloads
    
    $ localhost> ./launch.sh

## Notes for EC2

If you are going to load Oracle onto an EC2 instance, there are some additional changes needed to the Vagrantfile before you launch instances.

* Change 'Ebs.VolumeSize' to 40 or higher
* Change 'aws.ami' to the appropriate value
** us-east-1 = ami-aecd60c7
** us-west-2 = ami-48da5578
** eu-west-1 = ami-6d555119

# Usage

Login to the box and check oracle install

    vagrant ssh db2
    sudo su - tungsten
    sqlplus sys/password as sysdba
