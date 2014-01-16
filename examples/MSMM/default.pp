class { 'continuent_install' :
  installSSHKeys => true,
	installMysql => true,
	replicatorRepo => nightly,
	installReplicatorSoftware => true,
	installClusterSoftware => "/vagrant/continuent-tungsten-latest.noarch.rpm",
	clusterData => {
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
	},
}

if $ec2_instance_id == "" {
	host { "db1": ip => "192.168.11.101", } ->
	host { "db2": ip => "192.168.11.102", } ->
	host { "db3": ip => "192.168.11.103", } ->
	host { "db4": ip => "192.168.11.104", } ->
	host { "db5": ip => "192.168.11.105", } ->
	host { "db6": ip => "192.168.11.106", } ->
	Class["continuent_install"]
} else {
	class { "ec2_hosts": 
		include_short_hostname => true,
	} ->
	Class["continuent_install"]
}