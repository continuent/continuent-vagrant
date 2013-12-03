This directory builds a set of VMs that may be used for easily testing Continuent Tungsten solutions.

# Downloading

    $ localhost> git clone git@github.com:continuent/continuent-vagrant.git
    $ localhost> cd continuent-vagrant
    $ localhost> git submodule update --init

# Using VirtualBox

1. Download a VirtualBox image using either the 32-bit or 64-bit images below
1. Copy the Vagrantfile.vbox file to Vagrantfile
1. Update the Vagrantfile 'config.vm.box' value if you are using 64-bit

## Install a 32-bit base box

    $ localhost> vagrant box add centos-64-i386 http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-i386-v20130731.box

## Install a 64-bit base box

    $ localhost> vagrant box add centos-64-x64 http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box
    
# Using EC2

1. Make sure the 'default' security group allows SSH access from your machine
1. Install the vagrant-aws plugin. This will have issues on some versions of OS X.

        $ localhost> vagrant plugin install vagrant-aws     
1. Download a dummy image to start EC2 instances

        $ localhost> vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
1. Copy the Vagrantfile.ec2 file to Vagrantfile
1. Update fields at the top of Vagrantfile to match your environment

## Known Issues with EC2

### sudo: sorry, you must have a tty to run sudo

This can happen if the provisioning process runs to soon after the server starts. Just run `provision.sh` and it will try again.

# Starting the boxes the first time

Run the `relaunch.sh` script to launch all VMs and provision them in parallel. After starting the boxes the first time, you may use the `vagrant suspend` and `vagrant resume` commands.

# Installing your first cluster

1. Download the Continuent Tungsten RPM into the vagrant_continuent directory
2. 

        $ localhost> ./provision.sh
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