# Motherboard: ROG STRIX X570-E GAMING
{ ... }:

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/cpu/amd/zenpower.nix
    ../../../common/pc/ssd
  ];

  boot.kernelModules = [
    "btintel" # Bluetooth driver for Intel AX200 802.11ax
    "nct6775" # Temperature and Fan Sensor for Nuvoton NCT6798D-R
  ];
}

# Troubleshooting: Bluetooth device missing
#   There is a known electrical design problem in ROG Strix X570-E Gaming motherboard:
#   https://www.reddit.com/r/ASUS/comments/romkqq/bluetooth_and_wifi_stopped_working_rog_strix/
#   Whenever Bluetooth device fails to list (sudo dmesg | grep Bluetooth; hciconfig).
#   Consider:
#     1. Turning off computer.
#     2. Unplugging computer's power supply.
#     3. Holding down power button for 15s.
#     4. Bluetooth device should list then.
