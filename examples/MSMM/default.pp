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
$clusterRPM = "/vagrant/downloads/continuent-tungsten-latest.noarch.rpm"

$clusterData = {
	"defaults.replicator" => {
		"executable-prefix" => "mm",
	},
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

class { "continuent_vagrant" : }

class { 'tungsten' :
	installSSHKeys => true,
	installMysql => true,
	replicatorRepo => nightly,
	installReplicatorSoftware => true,
	installClusterSoftware => $clusterRPM,
	mySQLSetAutoIncrement=> true,
	clusterData => $clusterData,
}
