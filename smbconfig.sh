#!/bin/bash

# if not root, re-execute using sudo
if [[ $(id -u) -ne 0 ]] ; then
    exec sudo bash $0
fi

function test_retval {
    if (($? > 0)); then
	echo "Canceling"
	exit 1
    fi
}

HEIGHT=10
WIDTH=50

dialog --title "Share configuration" --clear --inputbox "Share path\nexample: \\\\myserver.somehwere.edu\\\data" $HEIGHT $WIDTH \
    2>.sharepath

test_retval

dialog --title "Share configuration" --clear --inputbox "Username to connect to share" $HEIGHT $WIDTH 2>.shareuser

test_retval

dialog --title "Share configuration" --clear --inputbox "Password to connect to share" $HEIGHT $WIDTH 2>.sharepwd

test_retval

dialog --title "Share configuration" --clear --inputbox "Mount point" $HEIGHT $WIDTH "/mnt/ifcb" 2>.sharemp

test_retval

sharepath=$(cat .sharepath | sed -e 's#\\#/#g')
shareuser=$(cat .shareuser)
sharepwd=$(cat .sharepwd)
sharemp=$(cat .sharemp)
rm .sharepath .shareuser .sharepwd .sharemp

# FIXME validate input

# unmount anything that's mounted at the mount point
umount $sharemp 2>/dev/null
# create the mount point if it does not exist
mkdir -p $sharemp

cat > .smbcredentials <<EOF
username=$shareuser
password=$sharepwd
EOF

# FIXME instead of echoing this, edit it into /etc/fstab
echo $sharepath $sharemp cifs credentials=/vagrant/.smbcredentials 0 0



