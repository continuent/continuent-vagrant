import 'vagrant_hosts.pp'

class { 'tungsten' :
	installSSHKeys => true,
}

class { 'cassandra' :
}
