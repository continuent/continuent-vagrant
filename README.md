This directory builds a set of VMs that may be used for easily testing Continuent Tungsten solutions. You will need to have [VirtualBox](https://www.virtualbox.org/) and [vagrant](http://www.vagrantup.com/) installed before you proceed.

# Quick Start

This process will start a 3-node cluster using 32-bit Virtualbox images.

    $ localhost> vagrant box add centos-64-i386 http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-i386-v20130731.box
    $ localhost> git clone https://github.com/continuent/continuent-vagrant.git
    $ localhost> cd continuent-vagrant
    $ localhost> git submodule update --init
    $ localhost> cp ~/continuent-tungsten-2.0.1-1002.noarch.rpm ./downloads/continuent-tungsten-latest.noarch.rpm
    $ localhost> cp examples/Vagrantfile.3.vbox ./Vagrantfile
    $ localhost> cp examples/STD/default.pp ./manifests/
    $ localhost> ./launch.sh
    
You can repeat this process with any of the examples subdirectories. View the README in that directory for more information. The launch.sh script will start the images and install the software. If you would like to do a manual install of Tungsten, remove 'clusterData => $clusterData,' from the manifests/default.pp file.

Once you are finished with the instances

    $ localhost> vagrant destroy -f

# Using a 64-bit base box

1. Download the 64-bit box

        $ localhost> vagrant box add centos-64-x64 http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box
    
1. Update your Vagrantfile to list "centos-64-x64" instead of "centos-64-i386"
    
# Using EC2

1. Make sure the 'default' security group allows SSH access from your machine
1. Install the vagrant-aws plugin. This will have issues on some versions of OS X.

        $ localhost> vagrant plugin install vagrant-aws     
1. Download a dummy image to start EC2 instances

        $ localhost> vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
1. Copy a examples/Vagrantfile.#.ec2 file to ./Vagrantfile
1. Update fields at the top of Vagrantfile to match your environment
2. Update the GROUP value if you are working with multiple continuent-vagrant directories

## Known Issues with EC2

### sudo: sorry, you must have a tty to run sudo

This can happen if the provisioning process runs to soon after the server starts. Just run `provision.sh` and it will try again.

### /usr/lib/ruby/1.9.1/rubygems/custom_require.rb:36:in `require': cannot load such file -- mkmf (LoadError)

This occurs when installing the vagrant-aws plugin on some Ubuntu versions. To resolve install the ruby1.9.1-dev package
on Centos/Redhat install

       sudo yum install -y gcc ruby-devel libxml2 libxml2-devel libxslt libxslt-devel
