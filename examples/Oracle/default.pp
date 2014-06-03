# Copyright (C) 2014 Continuent, Inc.
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