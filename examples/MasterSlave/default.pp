import 'vagrant_hosts.pp'

$clusterData = {
	"east" => {
		"topology" => "master-slave",
		"master" => "db1",
		"slaves" => "db2,db3",
	},
}

class { 'tungsten' :
	installSSHKeys => true,
	installMysql => true,
	replicatorRepo => stable,
	installReplicatorSoftware => true,
	clusterData => $clusterData,
}