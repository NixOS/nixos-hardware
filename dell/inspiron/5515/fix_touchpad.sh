#!/bin/sh

set -eux

unload () {
  if modprobe -r "$1" 2>&1;
  then echo ok
  else echo fail
  fi
}

wait_unload() {
  while sleep 1; do
    output="$(unload "$1")"
    case "$output" in
      *is\ in\ use*) :;;
      *ok*) return 0;;
      *) echo "modprobe said: $output"; echo giving up; return 1;
    esac
  done
}

wait_unload i2c_hid_acpi
wait_unload i2c_hid
modprobe i2c_hid
modprobe i2c_hid_acpi
