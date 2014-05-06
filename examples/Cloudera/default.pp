$replicatorPackage = "/vagrant/downloads/tungsten-replicator-latest.tar.gz"

anchor { "dbms::end" : }

if $fqdn == "db1" {
	$installMysql = true

	$clusterData = {
		"mh" => {
			"topology" => "master-slave",
			"master" => "db1",
			"members" => "db1,db2",
			"enable-heterogenous-service" => "true",
			"java-user-timezone" => "GMT",
			"property=replicator.filter.pkey.addColumnsToDeletes" => "true",
			"property=replicator.filter.pkey.addPkeyToInserts" => "true"
		},
	}
} else {
	Sysctl {
		provider => "augeas"
	}

	$installMysql = false

	class { 'cloudera' :
		cm_server_host => "db2",
		use_parcels => false,
		install_java => false,
	} ->
	file { "/user" :
		ensure => "directory",
	} ->
	exec { "/user/tungsten" :
		command => "/usr/bin/hadoop fs -mkdir /user/tungsten",
		unless => "/usr/bin/hadoop fs -test -d /user/tungsten"
	} ~>
	exec { "/user/tungsten:mode" :
		command => "/usr/bin/hadoop fs -chmod 700 /user/tungsten",
		refreshonly => true,
	} ~>
	exec { "/user/tungsten:owner" :
		command => "/usr/bin/hadoop fs -chown tungsten: /user/tungsten",
		refreshonly => true,
	} ->
	Anchor["dbms::end"]
	
	$clusterData = {
		"mh" => {
			"topology" => "master-slave",
			"master" => "db1",
			"members" => "db1,db2",
			"enable-heterogenous-service" => "true",
			"batch-enabled" => "true",
			"batch-load-language" => "js",
			"batch-load-template" => "hadoop",
			"datasource-type" => "file",
			"java-file-encoding" => "UTF8",
			"java-user-timezone" => "GMT",
			"svc-applier-block-commit-interval" => "1s",
			"svc-applier-block-commit-size" => "1000",
			"property=replicator.datasource.applier.csvType" => "hive",
			"skip-validation-check" => "DirectDatasourceDBPort,DatasourceDBPort"
		},
	}
}

class { "continuent_vagrant" : }

class { 'tungsten' :
	installSSHKeys => true,
	installMysql => $installMysql,
	installReplicatorSoftware => $replicatorPackage,
	clusterData => $clusterData
}

Anchor["dbms::end"] ->
Class["tungsten::tungsten"]