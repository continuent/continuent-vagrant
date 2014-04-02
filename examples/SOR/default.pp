class { "continuent_vagrant" : }

$clusterRPM = "/vagrant/downloads/continuent-tungsten-latest.noarch.rpm"

$clusterData = {
	"east" => {
		"topology" => "clustered",
		"master" => "db1",
		"slaves" => "db2,db3",
		"connectors" => "db1,db2,db3",
	},
	"west" => {
		"topology" => "clustered",
		"master" => "db4",
		"slaves" => "db5,db6",
		"connectors" => "db4,db5,db6",
		"relay-source" => "east",
	},
	"us" => {
		"composite-datasources" => "east,west",
	},
}

class { 'tungsten' :
	installSSHKeys => true,
	installMysql => true,
	installClusterSoftware => $clusterRPM,
	clusterData => $clusterData,
}