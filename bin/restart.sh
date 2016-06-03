#!/bin/bash

BIN_PATH=/vagrant/bin/do

# if not root, re-execute using sudo
if [[ $(id -u) -ne 0 ]] ; then
    exec sudo bash $0
fi

UP=$(. $BIN_PATH/do_status.sh)
if [[ $UP != 0 ]]; then
    dialog --yesno "Are you sure you want to restart the IFCB dashboard?" 10 40
    if [[ $? == 1 ]]; then
	exit 1
    fi
    . $BIN_PATH/do_shutdown.sh | dialog --progressbox "Stopping services" 10 50
    while [ 1 ]; do
	UP=$(. $BIN_PATH/do_status.sh)
	if [[ $UP == 0 ]]; then break; fi
	dialog --infobox "Waiting for services to shut down ..." 3 45
	sleep 1
    done
fi

. $BIN_PATH/do_startup.sh | dialog --progressbox "Starting services" 10 50

while [ 1 ]; do
    UP=$(. $BIN_PATH/do_status.sh)
    if [[ $UP == 3 ]]; then break; fi
    dialog --infobox "Waiting for services to come up ..." 3 45
    sleep 1
done
dialog --infobox "Dashboard started." 3 30

