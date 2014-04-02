$clusterData = {
	"fanin" => {
		"topology" => "fan-in",
		"masters" => "db1,db2",
		"master-services" => "alpha,bravo",
		"slaves" => "db3",
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