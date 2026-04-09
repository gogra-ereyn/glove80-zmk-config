#!/bin/bash
# flash glove80.uf2 to a half in bootloader mode

set -e

UF2="${1:-glove80.uf2}"
MNT="/mnt"

if [ ! -f "$UF2" ]; then
    echo "uf2 not found: $UF2" >&2
    exit 1
fi

# find the ~32M removable disk with no partitions
DEV=$(lsblk -dnro NAME,RM,SIZE,TYPE | awk '$2 == 1 && $4 == "disk" && $3 ~ /^3[0-9]\.?[0-9]*M$/ {print "/dev/"$1; exit}')

if [ -z "$DEV" ]; then
    echo "no glove80 in bootloader mode found — double-tap reset and try again" >&2
    exit 1
fi

echo "flashing $UF2 -> $DEV"
sudo mount "$DEV" "$MNT"
sudo cp "$UF2" "$MNT/"
sudo umount "$MNT"
echo "done — board will reboot"
