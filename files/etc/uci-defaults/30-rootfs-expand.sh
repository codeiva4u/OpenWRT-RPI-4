#!/bin/sh
if [ ! -f /etc/rootfs_expanded ]; then
    ROOT_PART=$(findmnt / -o SOURCE -n)
    ROOT_DEV=${ROOT_PART%?}
    PART_NUM=${ROOT_PART#$ROOT_DEV}
    umount / || true
    (echo d; echo $PART_NUM; echo n; echo p; echo $PART_NUM; echo; echo; echo w) | fdisk $ROOT_DEV
    touch /etc/rootfs_expanded
    echo "Root partition expanded. Rebooting now..."
    reboot
fi
exit 0