$clusterData = {
	"allmasters" => {
		"topology" => "all-masters",
		"masters" => "db1,db2,db3",
		"master-services" => "alpha,bravo,charlie",
	},
}

class { "continuent_vagrant" : }

class { 'tungsten' :
	installSSHKeys => true,
	installMysql => true,
	replicatorRepo => stable,
	installReplicatorSoftware => true,
	clusterData => $clusterData,
}