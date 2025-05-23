#!/bin/bash
#
# load cyw43 wireless firmware w/ bluetooth firmware 
# update the const values in main.rs if you change these locations.
#
# this version uses picotool, make sure its installed/built and the Pico2W is in BOOTSEL mode
set -e

# 0x100000000 = ROM base
# Load Wifi firmware @ 3MiB mark, 256KiB hole
picotool load --ignore-partitions -t bin include/cyw43-firmware/43439A0.bin -o 0x10300000

# Load Bluetooth firmware @ 1MiB + 256KiB, 16 KiB hole
picotool load --ignore-partitions -t bin include/cyw43-firmware/43439A0_btfw.bin -o 0x10340000

# load CLM firmware @ 1MiB + 256KiB + 16 KiB
picotool load --ignore-partitions -t bin include/cyw43-firmware/43439A0_clm.bin -o 0x10344000

echo "Firmware flashed w/ picotool successfully!"
