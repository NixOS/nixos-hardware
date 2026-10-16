
# Version 2

!! BREAKING CHANGE !!
Opting into the new state version will change your bluetooth MAC address
if you were using the previous stable random address. You have two options
to migrate. Note the MAC address and add it to the `bluetoothMAC` option,
or reconnect your bluetooth devices after the next reboot.

1. Create `stateVersion` option
2. Allow `wifiMAC` to be set to a stable address when null. Automatic, and random MAC using ""
3. Use new RFC for MAC generation.

# Version 1

1. `wifiMAC` is either set or random
2. `bluetoothMAC` is either set or stable random address based on machine-id

