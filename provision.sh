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
 
MAX_PROCS=4

OIFS=$IFS
IFS=" "
cd `dirname $0`
parallel_provision() {
    while read box; do
				rm -f $box.out.txt
				rm -f $box.out.log
        echo "Provisioning '$box'. Output will be in: $box.out.log" 1>&2
        echo $box
    done | xargs -P $MAX_PROCS -I"BOXNAME" \
        sh -c 'vagrant provision BOXNAME >BOXNAME.out.log 2>&1 || echo "Error Occurred: BOXNAME"'
}

set_hostfile() {

   rm -f hostfile.txt
   echo '127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4' > hostfile.txt
   for box in `echo $HOSTS| tr "\n" " "`
   do
      echo "Getting IP Details for $box" 1>&2
      ip=`vagrant ssh $box -c 'facter|grep ipaddress_eth0'|awk -F" " '{print $3}'|tail -n1|tr -d $'\r'`
      echo "$ip $box" >> hostfile.txt
    done
   for box in `echo $HOSTS| tr "\n" " "`
   do
      vagrant ssh $box -c "sudo echo \"`cat hostfile.txt`\"| sudo tee  /etc/hosts"
    done
}

IS_AWS=`grep vm.box Vagrantfile | grep dummy | wc -l`
IS_OS=`grep vm.box Vagrantfile | grep dummyOS | wc -l`
IS_VCENTER=`grep vm.provider Vagrantfile |head -n1| grep vcenter | wc -l`
IS_APPCATALYST=`grep vm.provider Vagrantfile |head -n1| grep vmware_appcatalyst | wc -l`

if [ "$*" == "" ]; then
	HOSTS=`vagrant status | grep -e 'running (' | awk -F" " '{print $1}'`
else
	HOSTS=`echo $* | tr " " "\n"`
fi
echo $HOSTS | parallel_provision

if [ $IS_OS -eq 1 ]
then
    set_hostfile
fi

if [ $IS_VCENTER  -eq 1 ]
then
    set_hostfile
fi

if [ $IS_APPCATALYST  -eq 1 ]
then
    set_hostfile
fi

IFS=$OIFS
