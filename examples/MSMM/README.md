# Installation

This is an example of setting up Multi-Site Multi-Master using Virtualbox. You can set this up in EC2 with the examples/MSMM/Vagrantfile.ec2 file. Follow the instructions in the main directory to make sure you are ready to use the selected platform.

    $ localhost> cd ~
    $ localhost> git clone git@github.com:continuent/continuent-vagrant.git msmm
    $ localhost> cd ~/msmm
    $ localhost> git submodule update --init
    $ localhost> cp examples/MSMM/default.pp ./manifests
    $ localhost> cp examples/MSMM/Vagrantfile.vbox ./Vagrantfile
    $ localhost> cp ~/continuent-tungsten-2.0.1-801.noarch.rpm ./continuent-tungsten-latest.noarch.rpm
    $ localhost> ./launch.sh

# Usage

## Viewing basic replication status

    $ localhost> cd ~/msmm
    $ localhost> vagrant ssh db1
    $ db1> alias multi_trepctl=/opt/replicator/tungsten/tungsten-replicator/scripts/multi_trepctl
    $ db1> multi_trepctl --by-service
    $ db1> multi_trepctl --role=master heartbeat
    $ db1> multi_trepctl --by-service
