#!/bin/sh
 
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
