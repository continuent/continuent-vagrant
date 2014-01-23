import 'vagrant_hosts.pp'

class { 'continuent_install' :
	installSSHKeys => true,
	installMysql => true,
}