#!/bin/bash

BIN_PATH=/home/vagrant/ifcb-dashboard/bin/do

if [[ $1 == "up" ]]; then
    SUCCESS=3
else
    SUCCESS=0
fi

while [ 1 ]; do
    UP=$(. $BIN_PATH/do_status.sh)
    if [[ $UP == $SUCCESS ]]; then break; fi
    sleep 1
done
