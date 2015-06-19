# Copyright (C) 2015 VMware, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.  You may obtain
# a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations
# under the License.

$replicatorPackage = "/vagrant/downloads/tungsten-replicator-4.0.0-2667425.tar.gz"

if $fqdn == "db1" {
	$mysql = true
	$verticaPackage = false
	$verticaDatabaseName = false
	$clusterData = {
		"east" => {
			"topology" => "master-slave",
			"master" => "db1",
			"slaves" => "db2",
			"enable-heterogeneous-service" => "true",
		},
	}
} else {
	$mysql = false
	$verticaPackage = "/vagrant/downloads/vertica-7.1.1-0.x86_64.RHEL5.rpm"
	$verticaDatabaseName = "bigdata"
	$clusterData = {
		"east" => {
			"topology" => "master-slave",
			"master" => "db1",
			"slaves" => "db2",
			"enable-heterogeneous-service" => "true",
			"batch-enabled" => "true",
			"batch-load-language" => "js",
			"batch-load-template" => "vertica6",
			"datasource-type" => "vertica",
			"replication-user" => "dbadmin",
			"vertica-dbname" => $verticaDatabaseName,
			"java-external-lib-dir" => "/opt/vertica/java/lib",
			"preferred-path" => "/opt/vertica/bin"
		},
	}
}

class { "continuent_vagrant" : }

class { 'tungsten' :
	installSSHKeys => true,
	installMysql => $mysql,
	overrideOptionsMysqld=>{'binlog-format'=>'row'},
	installVertica => $verticaPackage,
	verticaDatabaseName => $verticaDatabaseName,
	installReplicatorSoftware => $replicatorPackage,
	clusterData => $clusterData,
}