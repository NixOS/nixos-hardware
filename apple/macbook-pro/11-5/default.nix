{ lib, config, ... }:

let

  inherit (config.boot) kernelPackages;

in

{
  imports = [
    ../.
    ../../../common/pc/ssd
  ];

  # Enable broadcom-43xx firmware
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  services.udev.extraRules =
    # Disable XHC1 wakeup signal to avoid resume getting triggered some time
    # after suspend. Reboot required for this to take effect.
    lib.optionalString (lib.versionAtLeast kernelPackages.kernel.version "3.13")
      ''SUBSYSTEM=="pci", KERNEL=="0000:00:14.0", ATTR{power/wakeup}="disabled"'';
}
