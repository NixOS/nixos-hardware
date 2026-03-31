{ lib, ... }:

{
  # RTl8723BS Bluetooth
  boot.kernelPatches = [
    {
      name = "bt-hciuart-rtl";
      patch = null;
      structuredExtraConfig.BT_HCIUART_RTL = lib.kernel.yes;
    }
  ];

  # Load WiFi driver earlier to prevent race-conditions with Bluetooth driver
  boot.initrd.availableKernelModules = [
    "r8723bs"
    "libarc4"
    "cfg80211"
  ];
}
