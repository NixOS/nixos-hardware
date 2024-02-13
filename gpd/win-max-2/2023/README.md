# GPD Win Max 2 2023

## Gyro

The IMU (Bosch BMI260) is incorrectly identified in the BIOS. It's named BMI0160:00 in ACPI table.

The IMU is on `/dev/i2c-2`, address `0x69`. It's `CHIP_ID` in reg `0x00` is `0x27`, which could determine that it is actually BMI0260: https://chromium.googlesource.com/chromiumos/platform/ec/+/master/driver/accelgyro_bmi260.h#28
