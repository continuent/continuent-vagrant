## Copyright (C) 2015 VMWare Inc
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
$oracleRPM = "/vagrant/downloads/vmware-continuent-replication-oracle-source-latest.rpm"
if $fqdn == "db1" {
	$installMysql = true
	$installOracle= false
}
if $fqdn == "db2" {
	$installMysql = false
	$installOracle= true
}

class { "continuent_vagrant" : }

class { 'tungsten' :
	installSSHKeys => true,
	installMysql => false,
	installOracle => true,
	oracleVersion => 11,
	redoReaderTopology => 'MySQLToOracle',
	overrideOptionsMysqld=>{'binlog-format'=>'row'},
	installRedoReaderSoftware => $oracleRPM
}
