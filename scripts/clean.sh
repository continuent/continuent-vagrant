#!/bin/bash
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

cd `dirname $0`/..

if [ "$1" == "--i-am-sure" ]
then
	if [ -d /opt/continuent/ ] ; then
		if [ -d /opt/continuent/tungsten ]
		then
			/opt/continuent/tungsten/cluster-home/bin/stopall >/dev/null 2>&1
		fi

		find /opt/continuent -maxdepth 1 -mindepth 1 -not -name software -exec sudo rm -rf {} \;
	fi
	if [ -d /opt/replicator/ ] ; then
		if [ -d /opt/replicator/tungsten ]
		then
			/opt/replicator/tungsten/cluster-home/bin/stopall >/dev/null 2>&1
		fi

		find /opt/replicator -maxdepth 1 -mindepth 1 -not -name software -exec sudo rm -rf {} \;
	fi

	mysql -BN -e'select 1' >/dev/null 2>&1
	if [ "$?" == "0" ]
	then
		for D in $(mysql -BN -e 'SHOW SCHEMAS LIKE "tungsten%"' )
		do
			mysql -BN -e "SET SESSION SQL_LOG_BIN=0; DROP SCHEMA IF EXISTS $D" >/dev/null 2>&1
		done
		for D in $(mysql -BN -e 'SHOW SCHEMAS LIKE "tungsten%"' )
		do
			mysql -BN -e "SET SESSION SQL_LOG_BIN=0; DROP SCHEMA IF EXISTS $D" >/dev/null 2>&1
		done
		mysql -BN -e "SET SESSION SQL_LOG_BIN=0; DROP SCHEMA IF EXISTS test; CREATE SCHEMA test;" >/dev/null 2>&1
		mysql -BN -e 'SET GLOBAL read_only=OFF' >/dev/null 2>&1
		
		BINLOG_FORMAT=`my_print_defaults mysqld | grep binlog_format | awk -F= '{print $2}'`
		if [ "$BINLOG_FORMAT" == "" ]
		then
			BINLOG_FORMAT="mixed"
		fi
		
		mysql -BN -e "SET GLOBAL binlog_format=${BINLOG_FORMAT}" >/dev/null 2>&1
		mysql -BN -e 'RESET MASTER' >/dev/null 2>&1
	fi
else
	if [ "$1" == "-y" ]
	then
		./run.sh sudo /vagrant/scripts/clean.sh --i-am-sure
	else
		echo "This will empty Tungsten directories except for the contents of software."
		echo "The script will also reset all Tungsten schemas and the test schema."
		read -p "Are you sure? [y|N] " -r
		REPLY=`echo $REPLY | tr '[:upper:]' '[:lower:]'`
		if [[ $REPLY =~ ^(yes|y)$ ]]
		then
		    ./run.sh sudo /vagrant/scripts/clean.sh --i-am-sure
		fi
	fi
fi
