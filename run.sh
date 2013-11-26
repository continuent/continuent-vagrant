#!/bin/sh
 
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
 
HOSTS=`vagrant status | grep running | awk -F" " '{print $1}'`
echo $HOSTS | parallel

IFS=$OIFS