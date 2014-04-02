class { "continuent_vagrant" : }

$clusterRPM = "/vagrant/downloads/continuent-tungsten-latest.noarch.rpm"

$clusterData = {
	"east" => {
		"topology" => "clustered",
		"master" => "db1",
		"slaves" => "db2,db3",
		"connectors" => "db1,db2,db3",
	},
}

class { 'tungsten' :
	installSSHKeys => true,
	installMysql => true,
	installClusterSoftware => $clusterRPM,
	clusterData => $clusterData,
}