# Installation

    $ localhost> cd ~
    $ localhost> git clone git@github.com:continuent/continuent-vagrant.git std
    $ localhost> cd ~/std
    $ localhost> git submodule update --init
    $ localhost> cp examples/STD/default.pp ./manifests
    $ localhost> cp examples/Vagrantfile.3.vbox ./Vagrantfile
    $ localhost> cp ~/continuent-tungsten-2.0.1-1002.noarch.rpm ./downloads/continuent-tungsten-latest.noarch.rpm
    $ localhost> ./launch.sh

# Manual Installation

Follow the steps for installation but remove 'clusterData => $clusterData,' prior to running './launch.sh'. After the boxes are launched, proceed with these steps.
    
    $ localhost> vagrant ssh db1
    $ db1> sudo su - tungsten
    $ db1> cd /opt/continuent/software/continuent-tungsten-2.0.1-1002

    $ db1> ./tools/tpm configure defaults \
    --user=tungsten \
    --install-directory=/opt/continuent \
    --replication-user=tungsten \
    --replication-password=secret \
    --replication-port=13306 \
    --application-user=app_user \
    --application-password=secret \
    --application-port=3306 \
    --application-readonly-port=3307 \
    --start-and-report \
    --mysql-connectorj-path=/opt/mysql/mysql-connector-java-5.1.26-bin.jar \
    '--profile-script=~/.bash_profile'

    $ db1> ./tools/tpm configure east \
    --master=db1 \
    --slaves=db2,db3 \
    --connectors=db1,db2,db3

    $ db1> ./tools/tpm install