# B650 suspend bug

Just as the [B550 mainboard](../b550/README.md) series, the B650 series has a
bug where the PC will wakeup immediately after going into suspend.

## Affects at least

- Gigabyte B650M Aorus Elite AX (Rev. 1.3) (BIOS Version F32b)
  - Can not be fixed by modifying enabled entries in /proc/acpi/wakeup.
    Computer wakes up even if all enabled entries are disabled. Therefore, no
    fix exist currently.


