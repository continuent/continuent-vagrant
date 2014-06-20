   
## Using Openstack

Prior to starting, make sure the 'default' security group allows SSH access from your machine.

    $ localhost> vagrant plugin install vagrant-openstack-plugin  
    $ localhost> vagrant box add dummyOS https://github.com/cloudbau/vagrant-openstack-plugin/raw/master/dummy.box
    $ localhost> git clone https://github.com/continuent/continuent-vagrant.git
    $ localhost> cd continuent-vagrant
    $ localhost> git submodule update --init
    $ localhost> cp ~/continuent-tungsten-2.0.1-1002.noarch.rpm ./downloads/continuent-tungsten-latest.noarch.rpm
    $ localhost> cp examples/Vagrantfile.3.openstack ./Vagrantfile
    $ localhost> cp examples/STD/default.pp ./manifests/
    
Note: Currently there is an un-merged bug in the plugin that needs to be applied to make it work

https://github.com/mathuin/vagrant-openstack-plugin/commit/47d8533c6d323bc57bf269b822c8e9e3af0708cf

    
The launch.sh script will start the images and install the software. Update the files at the top of Vagrantfile to match your environment. 

    $ localhost> ./launch.sh

Once you are finished with the instances

    $ localhost> vagrant destroy -f

