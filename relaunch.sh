#!/bin/sh
 
MAX_PROCS=4

OIFS=$IFS
IFS=" "
cd `dirname $0` 
parallel_provision() {
    while read box; do
        echo "Provisioning '$box'. Output will be in: $box.out.txt" 1>&2
        echo $box
    done | xargs -P $MAX_PROCS -I"BOXNAME" \
        sh -c 'vagrant provision BOXNAME >BOXNAME.out.txt 2>&1 || echo "Error Occurred: BOXNAME"'
}
 
## -- main -- ##


vagrant destroy -f 
# start boxes sequentially to avoid vbox explosions

IS_AWS=`grep vm.box Vagrantfile | grep dummy | wc -l`
if [ $IS_AWS -eq 1 ]
then
  vagrant up --no-provision --provider=aws
else
  vagrant up --no-provision
fi

HOSTS=`vagrant status | grep -e 'running (' | awk -F" " '{print $1}'`
echo $HOSTS | parallel_provision

IFS=$OIFS
