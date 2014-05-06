# Installation

    $ localhost> cd ~
    $ localhost> git clone git@github.com:continuent/continuent-vagrant.git cloudera
    $ localhost> cd ~/cloudera
    $ localhost> git submodule update --init
    $ localhost> puppet module install -i ./modules razorsedge/cloudera
    $ localhost> cp examples/Cloudera/default.pp ./manifests
    $ localhost> cp examples/Vagrantfile.2.vbox ./Vagrantfile
    $ localhost> cp ~/tungsten-replicator-3.0.0-57.tar.gz ./downloads/tungsten-replicator-latest.tar.gz
    $ localhost> ./launch.sh