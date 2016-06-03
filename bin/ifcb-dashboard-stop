#!/bin/bash

BIN_PATH=/vagrant/bin/do

# if not root, re-execute using sudo
if [[ $(id -u) -ne 0 ]] ; then
    exec sudo bash $0
fi

UP=$(. $BIN_PATH/do_status.sh)
if [[ $UP == 0 ]]; then
    dialog --infobox "Dashboard already shut down." 3 40
    exit 1
fi

dialog --yesno "Are you sure you want to shut down the IFCB dashboard?" 10 30

if [[ $? == 0 ]]; then
    . $BIN_PATH/do_shutdown.sh | dialog --progressbox "Stopping services" 10 50
    while [ 1 ]; do
	UP=$(. $BIN_PATH/do_status.sh)
	if [[ $UP == 0 ]]; then break; fi
	dialog --infobox "Waiting for services to shut down ..." 3 45
	sleep 1
    done
    dialog --infobox "Dashboard shut down." 3 30
fi

