#!/bin/bash

# if not root, re-execute using sudo
if [[ $(id -u) -ne 0 ]] ; then
    exec sudo bash $0
fi

FSTAB=/etc/fstab

grep '\bcifs\b' $FSTAB | awk '{print $2}' | uniq > .allmounts

while read mp; do
    echo Unmounting $mp ...
    umount $mp
    rmdir $mp
done < .allmounts

echo Removing fstab entires ...
sed -i.bak -e '/\bcifs\b/d' $FSTAB


