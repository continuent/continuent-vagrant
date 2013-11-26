vagrant_continuent
==================

This directory builds a set of VMs that may be used for easily testing Continuent Tungsten solutions.

# Using VirtualBox

1. Download a VirtualBox image using either the 32-bit or 64-bit images below
1. Copy the Vagrantfile.vbox file to Vagrantfile
1. Update the Vagrantfile 'config.vm.box' value if you are using 64-bit

## Install a 32-bit base box

    shell> vagrant box add centos-64-i386 http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-i386-v20130731.box

## Install a 64-bit base box

    shell> vagrant box add centos-64-x64 http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box
    
# Using EC2

1. Create an EC2 VPC that uses '192.168.11.0/24' as the CIDR
1. Make sure you will be allowed to allocate 4 Elastic IPs. There is a default limit of 5 so you may need to request more from Amazon. Vagrant will not release the Elastic IPs when shutting down machines so you must go in and do that manually. It also will not reuse un-associated Elastic IPs so make sure the list is empty before starting.
1. Install the vagrant-aws plugin. This will have issues on some versions of OS X.

        $ localhost> vagrant plugin install vagrant-aws     
1. Download a dummy image to start EC2 instances

        $ localhost> vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
1. Copy the Vagrantfile.ec2 file to Vagrantfile
1. Update all fields in Vagrantfile to match your environment

# Starting the boxes the first time

Run the `relaunch.sh` script to launch all VMs and provision them in parallel. After starting the boxes the first time, you may use the `vagrant suspend` and `vagrant resume` commands.

# Installing your first cluster

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