class { "continuent_vagrant" : }

$clusterRPM = "/vagrant/downloads/continuent-tungsten-latest.noarch.rpm"

$clusterData = {
	"east" => {
		"topology" => "clustered",
		"master" => "db1",
		"members" => "db1,db2,db3",
		"connectors" => "db1,db2,db3",
	},
	"west" => {
		"topology" => "clustered",
		"master" => "db4",
		"members" => "db4,db5,db6",
		"connectors" => "db4,db5,db6",
	},
	"east_west" => {
		"topology" => "cluster-slave",
		"master-dataservice" => "east",
		"slave-dataservice" => "west",
		"thl-port" => "2113",
	},
	"west_east" => {
		"topology" => "cluster-slave",
		"master-dataservice" => "west",
		"slave-dataservice" => "east",
		"thl-port" => "2114",
	},
}

class { 'tungsten' :
	installSSHKeys => true,
	installMysql => true,
	replicatorRepo => nightly,
	installReplicatorSoftware => true,
	installClusterSoftware => $clusterRPM,
	clusterData => $clusterData,
}