import 'vagrant_hosts.pp'

if $fqdn == "db1" {
	$installMysql = true
} else {
	$installMysql = false
	
	class { 'continuent_oracle' :
	} -> 
	Class['continuent_install']
}

class { 'continuent_install' :
	installSSHKeys => true,
	installMysql => $installMysql,
}