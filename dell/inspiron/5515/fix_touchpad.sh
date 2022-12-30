#!/usr/bin/env bash

set -eux

wait-unload-module i2c_hid_acpi
wait-unload-module i2c_hid
modprobe i2c_hid
modprobe i2c_hid_acpi
