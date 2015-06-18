# Supported Platforms

This example will only work on VirtualBox. We are working on an option for EC2 but it is not available at this time.

# Installation

    $ localhost> cd ~
    $ localhost> git clone git@github.com:continuent/continuent-vagrant.git cloudera
    $ localhost> cd ~/cloudera
    $ localhost> git submodule update --init
    $ localhost> cp examples/Cloudera/default.pp ./manifests
    $ localhost> cp examples/Vagrantfile.2.vbox ./Vagrantfile
    $ localhost> cp ~/tungsten-replicator-3.0.0-57.tar.gz ./downloads/tungsten-replicator-latest.tar.gz
    $ localhost> ./launch.sh

# Initialize Materialized Views

    $ db2> sudo hive -e "CREATE DATABASE east_tungsten_create_load;"
    $ db2> sudo /opt/continuent/software/continuent-tools-hadoop/bin/load-reduce-check --no-compare -m /opt/continuent/share/materialize.json -s tungsten_create_load -Ujdbc:mysql:thin://db1:13306/tungsten_create_load -utungsten -psecret -S east

# Updating Materialized Views

    $ db2> sudo /opt/continuent/software/continuent-tools-hadoop/bin/materialize -m /opt/continuent/share/materialize.json -s tungsten_create_load
