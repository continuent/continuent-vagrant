# Installation

    $ localhost> cd ~
    $ localhost> git clone git@github.com:continuent/continuent-vagrant.git all
    $ localhost> cd ~/all
    $ localhost> git submodule update --init
    $ localhost> cp examples/FanIn/default.pp ./manifests
    $ localhost> cp examples/Vagrantfile.3.vbox ./Vagrantfile
    $ localhost> ./launch.sh

# Manual Installation

Follow the steps for installation but remove 'clusterData => $clusterData,' prior to running './launch.sh'. After the boxes are launched, proceed with these steps.
    
    $ localhost> vagrant ssh db1
    $ db1> sudo su - tungsten
    $ db1> cd /opt/continuent/software/tungsten-replicator-2.2.0-292

    $ db1> ./tools/tpm configure defaults \
    --user=tungsten \
    --install-directory=/opt/continuent \
    --replication-user=tungsten \
    --replication-password=secret \
    --replication-port=13306 \
    --start-and-report \
    '--profile-script=~/.bash_profile'

    $ db1> ./tools/tpm configure allmasters \
    --topology=fan-in \
    --master=db1,db2 \
    --master-services=alpha,bravo \
    --slaves=db3

    $ db1> ./tools/tpm install