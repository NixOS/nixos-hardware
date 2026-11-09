# QNAP TS-x33 family

These profiles expect a mainline U-Boot installation and use its extlinux
support. The TS-233 and TS-433 share an upstream U-Boot configuration; see the
[upstream TS-433 documentation][u-boot] for build and flashing instructions.
Prebuilt reproducible model-specific images are available from the
[TS-233/TS-433 bootloader builder][builder].

A dedicated ext4 partition on the internal eMMC, mounted at `/boot`, is
recommended for the extlinux configuration, kernels, initrds, and device trees;
the root filesystem can remain on SATA or USB. The generated
`/boot/extlinux/extlinux.conf` appears as `/extlinux/extlinux.conf` to U-Boot.
FAT32 also works but is only useful when compatibility with other firmware is
needed.

Mainline U-Boot boots the standard [NixOS aarch64 installer ISO][installer]
when written to a USB drive. Installation requires a 3.3 V USB-to-TTL serial
adapter with a 4-pin JST PH connector (2.0 mm pitch) at 115200 8N1. Connect TX,
RX, and ground only; do not connect VCC. This adapter is separate from the
USB-A-to-A cable used for maskrom flashing.

## PCB revision

Read the mainboard and backplane VPD product strings from their read-only
EEPROMs:

```console
$ sudo dd if="$(printf '%s\n' /sys/bus/i2c/devices/*-0054/eeprom)" bs=1 skip=66 count=22 status=none | tr -d '\000'; echo
$ sudo dd if="$(printf '%s\n' /sys/bus/i2c/devices/*-0056/eeprom)" bs=1 skip=106 count=22 status=none | tr -d '\000'; echo
```

The first line is the mainboard and the second is the backplane. For example,
`70-006Q0B2-001-120-RS` reports mainboard PCB 12, while
`70-010Q0B3-000-110-RS` reports backplane PCB 11. Compare both revisions with
the requirements on the model-specific page before selecting a PCB-specific
device tree.

The kernel device tree configures the QNAP MCU, which handles fan control,
case-temperature monitoring, red drive fault LEDs, USB and status LEDs, the
power button, buzzer, and peripheral power-off. No userspace fan-control service
is needed.

Green drive LEDs are GPIO-controlled and default to the global `disk-activity`
trigger. Current mainline Linux does not expose the chassis LAN LED.

[builder]: https://github.com/dbast/qnap-ts-433-bootloader-builder
[installer]: https://nixos.org/download/#nixos-iso
[u-boot]: https://docs.u-boot.org/en/stable/board/qnap/ts433.html
