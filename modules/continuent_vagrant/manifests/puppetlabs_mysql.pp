# == Class: continuent_vagrant::puppetlabs_mysql See README.md for documentation.
#
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

class continuent_vagrant::puppetlabs_mysql (
  $availableMastersData = false
) {
  include percona_repo
  include continuent_vagrant
  
  Class["continuent_vagrant::hosts"] ->
  class { 'mysql::server' :
    package_name => "Percona-Server-server-55",
    service_name => "mysql",
    root_password => "MyRootPassword",
    override_options => {
      "mysqld" => {
        "bind_address" => "0.0.0.0",
        "server_id" => fqdn_rand(5000,$ipaddress),
        "log-bin" => "mysql-bin",
        "binlog_format" => "ROW",
        "pid-file" => "/var/lib/mysql/mysql.pid",
        "port" => "13306",
        "open_files_limit" => "65535",
        "sync_binlog" => 2,
        "max_allowed_packet" => 64m,
        "auto_increment_increment" => getMySQLAutoIncrementIncrement($availableMastersData),
        "auto_increment_offset" => getMySQLAutoIncrementOffset($availableMastersData, $fqdn),
      },
    },
    restart => true,
  } ->
  class { 'mysql::client' :
    package_name => "Percona-Server-client-55",
  } ->
  package { "continuent_vagrant::puppetlabs_mysql::percona-xtrabackup" : 
    ensure => present, 
    name => "percona-xtrabackup",
  }
}