#!/usr/bin/env bash

set -euo pipefail

##
# For some reason /dev/ttyS0 is created, and then removed by udev. We need this
# for bluetooth, and the only way to get it again is to reload 8502_dw. Do so.
##


##
# /sys/devices/pci0000:00/0000:00:1e.0/driver -> intel-lpss
# /sys/bus/pci/devices/0000:00:1e.0
# /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:8a/BCM2E7C:00
##

# udevadm info --query=all --path=/sys/bus/serial/devices/serial0-0
# P: /devices/pci0000:00/0000:00:1e.0/dw-apb-uart.2/serial0/serial0-0
# M: serial0-0
# R: 0
# U: serial
# E: DEVPATH=/devices/pci0000:00/0000:00:1e.0/dw-apb-uart.2/serial0/serial0-0
# E: SUBSYSTEM=serial
# E: MODALIAS=acpi:BCM2E7C:APPLE-UART-BLTH:
# E: USEC_INITIALIZED=12406199
# E: PATH=/nix/store/56jhf2k9q31gwvhjxmm2akkkhi4a8nz1-udev-path/bin:/nix/store/56jhf2k9q31gwvhjxmm2akkkhi4a8nz1-udev-path/sbin
# E: ID_VENDOR_FROM_DATABASE=Broadcom


if [[ ! -e "/sys/devices/pci0000:00/0000:00:1e.0/dw-apb-uart.2/tty/ttyS0" ]]; then
    if [[ -e /sys/module/8250_dw ]]; then
        rmmod 8250_dw
    fi

    modprobe 8250_dw
fi

exec btattach --protocol=h4 --bredr=/dev/ttyS0 --speed=3000000
