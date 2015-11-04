This directory builds a set of VMs that may be used for easily testing Continuent Tungsten solutions. You will need to have [VirtualBox](https://www.virtualbox.org/) and [vagrant](http://www.vagrantup.com/) installed before you proceed.

# Quick Start

You can repeat this process with any of the examples subdirectories. View the README in that directory for more information. If you would like to do a manual install of Tungsten, remove 'clusterData => $clusterData,' from the manifests/default.pp file.

## Using VirtualBox

This process will start a 3-node cluster using 64-bit Virtualbox images.

    $ localhost> vagrant plugin install vagrant-puppet-install
    $ localhost> vagrant box add centos-64-x64 http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box
    $ localhost> git clone https://github.com/continuent/continuent-vagrant.git
    $ localhost> cd continuent-vagrant
    $ localhost> git submodule update --init
    
    # If using an RPM Build
    $ localhost> cp ~/continuent-tungsten-4.0.0-2667425.noarch.rpm ./downloads/continuent-tungsten-latest.noarch.rpm
    
    # ..or, if using the TAR Build
    $ localhost> cp ~/continuent-tungsten-4.0.0-2667425.tar.gz ./downloads
    $ localhost> vi manifests/default.pp
    # Change the clusterRPM line to: $clusterRPM = "/vagrant/downloads/continuent-tungsten-4.0.0-2667425.tar.gz"
    
    $ localhost> cp examples/Vagrantfile.3.vbox ./Vagrantfile
    $ localhost> cp examples/STD/default.pp ./manifests/

The launch.sh script will start the images and install the software.

    $ localhost> ./launch.sh

Once you are finished with the instances

    $ localhost> vagrant destroy -f

## Using EC2

Prior to starting, make sure the 'default' security group allows SSH access from your machine.

    $ localhost> vagrant plugin install vagrant-aws
    $ localhost> vagrant plugin install vagrant-puppet-install  
    $ localhost> vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
    $ localhost> git clone https://github.com/continuent/continuent-vagrant.git
    $ localhost> cd continuent-vagrant
    $ localhost> git submodule update --init
    $ localhost> cp ~/continuent-tungsten-2.0.4-589.noarch.rpm ./downloads/continuent-tungsten-latest.noarch.rpm
    $ localhost> cp examples/Vagrantfile.3.ec2 ./Vagrantfile
    $ localhost> cp examples/STD/default.pp ./manifests/

The launch.sh script will start the images and install the software. Update the files at the top of Vagrantfile to match your environment. Modify the GROUP value if you are working with multiple continuent-vagrant directories.

    $ localhost> ./launch.sh

Once you are finished with the instances

    $ localhost> vagrant destroy -f


## Using VMware vCenter

    This process will start a 3-node cluster using 64-bit vCenter images.

        $ localhost> vagrant plugin install vagrant-puppet-install
        $ localhost> vagrant plugin install vagrant-vmware-fusion
        $ localhost> vagrant plugin install vagrant-vcenter
        
        # Remove the vagrant-vmware-fusion plugin. It is a prereq
        # for vagrant-vcenter but will cause errors if left in place
        $ localhost> vagrant plugin uninstall vagrant-vmware-fusion
        $ localhost> git clone https://github.com/continuent/continuent-vagrant.git
        $ localhost> cd continuent-vagrant
        $ localhost> git submodule update --init
        $ localhost> cp ~/continuent-tungsten-2.0.4-589.noarch.rpm ./downloads/continuent-tungsten-latest.noarch.rpm
        $ localhost> cp examples/Vagrantfile.3.vcenter ./Vagrantfile
        $ localhost> cp examples/STD/default.pp ./manifests/

    Customize the variables in the Vagrantfile to match your vCenter environment. Be sure to adjust the IP addresses and routing information to match your network.

    The launch.sh script will start the images and install the software.

        $ localhost> ./launch.sh

    Once you are finished with the instances

        $ localhost> vagrant destroy -f



# Using the vagrant-cachier plugin

The vagrant-cachier plugin can keep packages on your machine so they don't need to be downloaded multiple times.

    $ localhost > vagrant plugin install vagrant-cachier

Add this to your Vagrantfile after the 'config.vm.network' line.

    if Vagrant.has_plugin?("vagrant-cachier")
      # Configure cached packages to be shared between instances
      # of the same base box.
      config.cache.scope = :box
    end

You may get errors the first time you run the `./launch.sh` script. Try starting up your servers with `vagrant up` the first time. The `./launch.sh` script should run properly after that.

# Automatic AWS instance shutdown

Add the `SHUTDOWN_TIMER` constant to the top of your AWS Vagrantfile. If defined, the AWS instance will automatically shutdown after the defined number of minutes has passed.

    # This will force a shutdown in 4 hours
    SHUTDOWN_TIMER = 240

You can cancel this process if you later decide that the instances should not be stopped.

    $ localhost > vagrant ssh db1
    $ db1 > sudo shutdown -c

# Known Issues

## sudo: sorry, you must have a tty to run sudo

This can happen if the provisioning process runs to soon after the server starts. Just run `provision.sh` and it will try again.

## /usr/lib/ruby/1.9.1/rubygems/custom_require.rb:36:in `require': cannot load such file -- mkmf (LoadError)

This occurs when installing the vagrant-aws plugin on some Ubuntu versions. To resolve install the ruby1.9.1-dev package
on Centos/Redhat install

       sudo yum install -y gcc ruby-devel libxml2 libxml2-devel libxslt libxslt-devel

## Using a windows client

Ensure your local git client is correctly setup to not translate Unix CR and LF characters. If it does it breaks the puppet install.

Replace launch.sh in the setup steps with vagrant up

## Unknown configuration section 'puppet_install'.

Ensure the puppet_install plug in is installed. You may need to upgrade to the latest version of Vagrant for it to install properly.

   $ localhost> vagrant plugin install vagrant-puppet-install
