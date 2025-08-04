#!/bin/sh

# This script expands the root partition to fill the SD card.
# It is designed for Raspberry Pi devices.

# Only run once
if [ -f /etc/rootfs_expanded ]; then
    exit 0
fi

# Get the root device and partition number
ROOT_DEV=$(findmnt / -o source -n)
PART_NUM=$(echo ${ROOT_DEV} | grep -o '[0-9]*$')
DISK=$(echo ${ROOT_DEV} | sed -e "s/${PART_NUM}$//")

# Check if we are on a valid mmcblk device
if ! echo "${DISK}" | grep -q "mmcblk"; then
    echo "Not running on a recognized SD card (mmcblk). Aborting."
    exit 1
fi

echo "Expanding ${ROOT_DEV} on disk ${DISK}..."

# Use fdisk to delete and recreate the partition with a larger size
# This is safe as long as we don't touch the start sector.
START_SECTOR=$(fdisk -l ${DISK} | grep ${ROOT_DEV} | awk '{print $2}')

# Unmount the partition temporarily if possible (might not be needed)
# umount -l ${ROOT_DEV}

# Recreate the partition
fdisk ${DISK} <<EOF
d
${PART_NUM}
n
p
${PART_NUM}
${START_SECTOR}

w
EOF

echo "Partition resized. Rebooting to apply changes..."

# Mark that the expansion is done so it doesn't run again
touch /etc/rootfs_expanded

# Reboot to allow the kernel to see the new partition size
reboot