# Lenovo ThinkPad X1 Carbon (14th Gen)

Tested on a 21V7 with a Core Ultra 7 356H, a 2880x1800 panel, BIOS N4OET53W (1.16), on Linux 7.3.

Set `hardware.enableRedistributableFirmware = true` for
the GPU (GuC, HuC, GSC, DMC), audio DSP (`sof-firmware`), Wi-Fi, Bluetooth, and NPU.

## Audio

BIOS 1.10 (N4OET47W) has a bug that breaks the 3.5 mm headset jack - see
<https://github.com/thesofproject/linux/issues/5770>.
Update past that with `fwupd` (`services.fwupd.enable = true`, run `fwupdmgr update`).

## Camera

Lenovo ships two camera modules in the X1 Gen 14.

- The USB camera appears in `lsusb` as "Chicony Electronics Integrated Camera".
  `uvcvideo` runs it with no extra configuration.

- The MIPI camera uses the Panther Lake IPU7 and appears in `lspci`.
  Mainline Linux and libcamera do not fully support this camera at time of writing.

## Known log messages

These messages show at boot and do not cause problems:

- `hid_sensor_prox ... probe with driver hid_sensor_prox failed with error -1`
- `intel-hid INTC10CC:00: failed to set button capability`
- `i801_smbus 0000:00:1f.4: SMBus is busy, can't use it!`
- `ucsi_acpi USBC000:00: conN: Firmware bug: duplicate port altmode SVID 0x17ef`
- `ucsi_acpi USBC000:00: GET_CABLE_PROPERTY failed (-95)`
