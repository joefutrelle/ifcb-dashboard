!#!/bin/bash

# if not root, re-execute using sudo
if [[ $(id -u) -ne 0 ]] ; then
    exec sudo bash $0
fi

function test_retval {
    if (($? > 0)); then
	echo "Canceled"
	exit 1
    fi
}

HEIGHT=10
WIDTH=50

sharepath="\\\\"

while [[ ! $sharepath =~ ^\\\\.*\\[^\\]+$ ]]; do
    dialog --title "Share configuration" --clear --inputbox "Share path\nexample: \\\\myserver.somehwere.edu\\\data$msg" $HEIGHT $WIDTH $sharepath \
        2>.sharepath
    test_retval
    sharepath=$(cat .sharepath)
    msg="\ninvalid share path: \"$sharepath\""
done
sharepath=$(echo $sharepath | sed -e 's#\\#/#g')

dialog --title "Share configuration" --clear --inputbox "Username to connect to share" $HEIGHT $WIDTH 2>.shareuser
test_retval
shareuser=$(cat .shareuser)

dialog --title "Share configuration" --clear --inputbox "Password to connect to share" $HEIGHT $WIDTH 2>.sharepwd
test_retval
sharepwd=$(cat .sharepwd)

dialog --title "Share configuration" --clear --inputbox "Mount point" $HEIGHT $WIDTH "/mnt/ifcb" 2>.sharemp
test_retval
sharemp=$(cat .sharemp)

rm .sharepath .shareuser .sharepwd .sharemp

# unmount anything that's mounted at the mount point
umount $sharemp 2>/dev/null
# create the mount point if it does not exist
mkdir -p $sharemp

cat > .smbcredentials <<EOF
username=$shareuser
password=$sharepwd
EOF

FSTAB=/vagrant/fstab # FIXME debug

# ensure marker is in fstab
MARKER="# IFCB data mount"

fgrep -q "$MARKER" $FSTAB
if [[ $? == 0 ]]; then
    sed -n -i.bak -e "/.*$MARKER/d" $FSTAB
fi

# FIXME instead of echoing this, edit it into /etc/fstab
echo $sharepath $sharemp cifs credentials=/vagrant/.smbcredentials 0 0 $MARKER >> $FSTAB

# mount

# test mount



