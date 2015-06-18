# Installation

    $ localhost> cd ~
    $ localhost> git clone git@github.com:continuent/continuent-vagrant.git vertica
    $ localhost> cd ~/vertica
    $ localhost> git submodule update --init
    $ localhost> cp examples/Vertica/default.pp ./manifests
    $ localhost> cp examples/Vagrantfile.2.vbox ./Vagrantfile
    $ localhost> cp ~/tungsten-replicator-4.0.0-2667425.tar.gz ./downloads
    $ localhost> cp ~/vertica-7.1.1-0.x86_64.RHEL5.rpm ./downloads
    $ localhost> ./launch.sh

# Create Schemas

db2>  ddlscan -user tungsten -pass secret -url 'jdbc:mysql:thin://db1:13306/tungsten_create_load' -db tungsten_create_load -template ddl-mysql-vertica.vm | vsql -Udbadmin -wsecret bigdata

db2>  ddlscan -user tungsten -pass secret -url 'jdbc:mysql:thin://db1:13306/tungsten_create_load' -db tungsten_create_load -template ddl-mysql-vertica-staging.vm | vsql -Udbadmin -wsecret bigdata