#!/bin/bash

# if not root, re-execute using sudo
if [[ $(id -u) -ne 0 ]] ; then
    exec sudo bash $0 $1
fi

function test_retval {
    if (($? > 0)); then
	echo "Canceled"
	exit 1
    fi
}

HEIGHT=10
WIDTH=50

sharehost=""

if [[ $1 = "ifcb" ]]; then
    CREDENTIALS_FILE=/vagrant/.ifcb_share_credentials
    HOST_DESCRIPTION=IFCB
    HOST_EXAMPLE=192.168.1.23
    DEFAULT_MOUNT_POINT=/mnt/ifcb
else
    CREDENTIALS_FILE=/vagrant/.data_share_credentials
    HOST_DESCRIPTION=server
    HOST_EXAMPLE=myserver.somewhere.edu
    DEFAULT_MOUNT_POINT=/mnt/ifcb_data
fi

dialog --title "Share configuration" --clear --inputbox "Name or IP address of $HOST_DESCRIPTION\nexample: $HOST_EXAMPLE" $HEIGHT $WIDTH $sharehost \
        2>.sharehost
test_retval
sharehost=$(cat .sharehost)

dialog --title "Share configuration" --clear --inputbox "Username to connect to share" $HEIGHT $WIDTH 2>.shareuser
test_retval
shareuser=$(cat .shareuser)

dialog --title "Share configuration" --clear --inputbox "Password to connect to share" $HEIGHT $WIDTH 2>.sharepwd
test_retval
sharepwd=$(cat .sharepwd)

cat > $CREDENTIALS_FILE <<EOF
username=$shareuser
password=$sharepwd
EOF

rm .sharehost .shareuser .sharepwd

if [[ $HOST_DESCRIPTION = IFCB ]]; then
    share=data
else
    smbclient -L $sharehost -A $CREDENTIALS_FILE -g 2>/dev/null >.smbclient

    if [[ ! $? == 0 ]]; then
	dialog --title "Connection error" --msgbox "Cannot connect to \"$sharehost\"\nCheck server address and username/password" 8 30
	exec sudo bash $0 $1
    fi

    sed -n -e '/^Disk/s/Disk|\(.*\)|.*/\1/p' .smbclient > .sharelist 2>/dev/null
    count=$(wc -l .sharelist | sed -e 's/ .*//')

    dialog --title "Share configuration" --clear --menu "Select a share" 16 30 $count $(cat -n .sharelist) 2>.sharechoice
    test_retval
    sharechoice=$(cat .sharechoice)

    share=$(sed -e "$sharechoice!d" .sharelist)
fi

rm .smbclient .sharelist .sharechoice

while [[ ! "$sharemp" =~ ^/[^\ ]+$  ]]; do
    dialog --title "Share configuration" --clear --inputbox "Mount point$msg" $HEIGHT $WIDTH "$DEFAULT_MOUNT_POINT" 2>.sharemp
    test_retval
    sharemp=$(cat .sharemp)
    msg="\nInvalid path: $sharemp"
done

rm .sharemp

# now perform the mount

FSTAB=/etc/fstab

# ensure marker is in fstab
MARKER="# IFCB dashboard $HOST_DESCRIPTION mount"

fgrep -q "$MARKER" $FSTAB
if [[ $? == 0 ]]; then
    # unmount existing share and delete mount point
    existing_mp=$(fgrep "$MARKER" $FSTAB | awk '{print $2}')

    if [ ! -z "$existing_mp" ]; then
	umount $existing_mp
	rmdir $existing_mp
    fi

    # remove entry
    sed -i.bak -e "/.*$MARKER/d" $FSTAB
fi

sharepath=//$sharehost/$share

# edit line into fstab
echo $sharepath $sharemp cifs credentials=$CREDENTIALS_FILE 0 0 $MARKER >> $FSTAB

# attempt to mount
mkdir -p $sharemp

dialog --title "Mounting share" --infobox "Please wait..." 4 40
mount $sharemp

if [[ ! $? == 0 ]]; then
    dialog --title "Error" --ok-label "Reconfigure" --msgbox "Unable to mount share" 6 30
    exec sudo bash $0 $1
fi    

dialog --title "Success" --infobox "Mounted share" 4 40

