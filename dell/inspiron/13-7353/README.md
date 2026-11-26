# Dell Inspiron 13-7353

13" 2-in-1 convertible from the Inspiron 7000 series: Intel Core
i7-6500U / i5-6200U (Skylake) with HD 520 graphics, Intel Wireless 3165,
SATA M.2 storage, and an Elan touchpad/touchscreen.

Everything works with mainline kernels via UEFI. The Skylake module this
profile imports configures GuC (`i915.enable_guc=2`), the legacy
`intel-vaapi-driver` with hybrid codec support, and the legacy
`intel-compute-runtime` appropriate for Gen9 graphics.

## Known issues

Boot-time firmware noise from the stock BIOS — all harmless:

- `DMAR: [Firmware Bug]: ... bad RMRR`
- `tpm_crb MSFT0101:00: [Firmware Bug]: ACPI region does not cover the
  entire command/response buffer`
- `ACPI Warning: \_SB.IETM._ART: Return Package type mismatch` /
  `_ART package 0 is invalid, ignored`
- `psmouse serio1: elantech: elantech_send_cmd query 0x02 failed` (the
  touchpad still works via I2C)
