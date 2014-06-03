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
 
## -- main -- ##


vagrant destroy -f $*
# start boxes sequentially to avoid vbox explosions

IS_AWS=`grep vm.box Vagrantfile | grep dummy | wc -l`
if [ $IS_AWS -eq 1 ]
then
  vagrant up --no-provision --provider=aws $*
	sleep 5
else
  vagrant up --no-provision $*
fi

if [ "$*" == "" ]; then
	HOSTS=`vagrant status | grep -e 'running (' | awk -F" " '{print $1}'`
else
	HOSTS=`echo $* | tr " " "\n"`
fi
echo $HOSTS | parallel_provision

IFS=$OIFS
