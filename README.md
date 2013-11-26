vagrant_continuent
==================

This directory builds a set of VMs that may be used for easily testing Continuent Tungsten solutions.

Download the base boxes
---

Install a 32-bit base box

    shell> vagrant box add centos-64-i386 http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-i386-v20130731.box

Install a 64-bit base box

    shell> vagrant box add centos-64-x64 http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box

Starting the boxes the first time
---

Run the `relaunch.sh` script to launch all VMs and provision them in parallel. After starting the boxes the first time, you may use the `vagrant suspend` and `vagrant resume` commands.

Installing your first cluster
---

1. Download the Continuent Tungsten RPM into the vagrant_continuent directory
2. 

        $ localhost> ./run.sh sudo rpm -i /vagrant/continuent-tungsten-2.0.1-751.noarch.rpm 
3. 

        $ localhost> vagrant ssh db1
4. 

        $ db1> sudo su - tungsten
5. 

        $ db1> cd /opt/continuent/software/continuent-tungsten-2.0.1-751
4. 

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
5. 

        $ db1> ./tools/tpm configure demo \
        --master=db1 \
        --slaves=db2,db3,db4 \
        --connectors=db1,db2,db3,db4
6. 

        $ db1> ./tools/tpm install