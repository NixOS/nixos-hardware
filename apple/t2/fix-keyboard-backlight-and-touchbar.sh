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

wait_unload apple_touchbar
modprobe apple_touchbar

# After suspend, the inode for the backlight device has changed. This service
# simply restarts upower to inform it of that change.
systemctl restart upower.service
