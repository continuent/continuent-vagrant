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
PROVIDER='virtualbox'
CHECKSTRING='running ('

OIFS=$IFS
IFS=" "
cd `dirname $0`

set_hostfile() {

   rm -f hostfile.txt
   for box in `echo $HOSTS| tr "\n" " "`
   do
      echo "Getting IP Details for $box" 1>&2
      ip=`vagrant ssh $box -c 'facter|grep ipaddress_eth0'|awk -F" " '{print $3}'|tail -n1|tr -d $'\r'`
      echo $ip
      echo "$ip $box" >> hostfile.txt
    done
   for box in `echo $HOSTS| tr "\n" " "`
   do
      vagrant ssh $box -c "sudo echo \"`cat hostfile.txt`\" >> /etc/hosts"
    done
}

parallel_provision() {
    while read box; do
				rm -f $box.out.txt
				rm -f $box.out.log
        echo "Provisioning '$box'. Output will be in: $box.out.log" 1>&2
        echo $box
    done | xargs -P $MAX_PROCS -I"BOXNAME" \
        sh -c 'vagrant provision BOXNAME >BOXNAME.out.log 2>&1 || echo "Error Occurred: BOXNAME"'
}
 
## -- main -- ##


vagrant destroy -f $*
# start boxes sequentially to avoid vbox explosions

IS_AWS=`grep vm.box Vagrantfile | grep dummy | wc -l`
IS_OS=`grep vm.box Vagrantfile | grep dummyOS | wc -l`

if [ $IS_AWS -eq 1 ]
then
    PROVIDER='aws'
    CHECKSTRING='running ('
fi

if [ $IS_OS -eq 1 ]
then
    PROVIDER='openstack'
    CHECKSTRING='active ('
fi

vagrant up --no-provision --provider=$PROVIDER $*
sleep 5

if [ "$*" == "" ]; then
	HOSTS=`vagrant status | grep -e "$CHECKSTRING" | awk -F" " '{print $1}'`
else
	HOSTS=`echo $* | tr " " "\n"`
fi

if [ $IS_OS -eq 1 ]
then
    set_hostfile

fi

echo $HOSTS | parallel_provision

IFS=$OIFS
