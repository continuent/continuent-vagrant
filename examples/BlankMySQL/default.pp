class { "continuent_vagrant" : }

class { 'tungsten' :
	installSSHKeys => true,
	installMysql => true
}