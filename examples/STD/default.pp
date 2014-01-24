import 'vagrant_hosts.pp'

$clusterRPM = "/vagrant/downloads/continuent-tungsten-latest.noarch.rpm"

$clusterData = {
	"east" => {
		"topology" => "clustered",
		"master" => "db1",
		"members" => "db1,db2,db3",
		"connectors" => "db1,db2,db3",
	},
}

class { 'continuent_install' :
	installSSHKeys => true,
	installMysql => true,
	installClusterSoftware => $clusterRPM,
	clusterData => $clusterData,
}