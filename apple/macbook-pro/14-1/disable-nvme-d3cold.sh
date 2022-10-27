#!/usr/bin/env bash

driver_path=/sys/bus/pci/devices/0000:01:00.0

if [[ ! -e "$driver_path" ]]; then
    echo "$driver_path does not exist, exiting..."
    exit 1
fi

driver=$(basename $(readlink "$driver_path/driver"))

if [[ "$driver" -ne "nvme" ]]; then
    echo "$driver_path is not an NVME device, got $driver, exiting..."
    exit 1
fi

echo 0 > "$driver_path/d3cold_allowed"

