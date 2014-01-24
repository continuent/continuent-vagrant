# Installation

    $ localhost> cd ~
    $ localhost> git clone git@github.com:continuent/continuent-vagrant.git oracle
    $ localhost> cd ~/oracle
    $ localhost> git submodule update --init
    $ localhost> cp examples/Oracle/default.pp ./manifests
    $ localhost> cp examples/Vagrantfile.3.vbox ./Vagrantfile
    
Download [Oracle 11g Database Installer](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/112010-linx8664soft-100572.html) to ./downloads
    
    $ localhost> ./launch.sh

# Usage

Login to the box and check oracle install

    vagrant ssh db2
    sudo su - tungsten
    sqlplus sys/password as sysdba