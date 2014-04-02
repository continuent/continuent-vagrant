if $fqdn == "db1" {
	$installMysql = true
	
	$clusterData = {
		"mo" => {
			"topology" => "master-slave",
			"master" => "db1",
			"members" => "db1,db2",
			"enable-heterogenous-service" => "true",
		},
	}
} else {
	$installMysql = false
	
	class { 'oracle' :
	} -> 
	Class['tungsten']
	
	$clusterData = {
		"mo" => {
			"topology" => "master-slave",
			"master" => "db1",
			"members" => "db1,db2",
			"enable-heterogenous-service" => "true",
			"datasource-type" => "oracle",
			"datasource-oracle-service" => "ORCL",
			"replication-user" => "tungsten_mo",
			"replication-password" => "secret",
		},
	}
}

class { "continuent_vagrant" : }

class { 'tungsten' :
	installSSHKeys => true,
	installMysql => $installMysql,
	replicatorRepo => nightly,
	installReplicatorSoftware => true,
	clusterData => $clusterData,
}