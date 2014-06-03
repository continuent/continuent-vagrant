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

COMMAND="vagrant ssh BOXNAME -- $@"
parallel() {
    while read box; do
        echo $box
    done | xargs -P $MAX_PROCS -I"BOXNAME" \
        $COMMAND
}
 
HOSTS=`vagrant status | grep -e 'running (' | awk -F" " '{print $1}'`
echo $HOSTS | parallel

IFS=$OIFS
