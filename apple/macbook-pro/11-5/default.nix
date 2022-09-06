{ lib, config, pkgs, ... }:

let

  kernelPackages = config.boot.kernelPackages;

in

{
  imports = [
    ../.
    ../../../common/pc/laptop/ssd

    # Radeon Venus XT is a GCN 1 microarchitecture
    # (amdgpu driver support is experimental and must be explicitly enabled)
    ../../../common/gpu/amd/southern-islands
  ];

  # Enable broadcom-43xx firmware
  hardware.enableRedistributableFirmware = true;

  services.udev.extraRules =
    # Disable XHC1 wakeup signal to avoid resume getting triggered some time
    # after suspend. Reboot required for this to take effect.
    lib.optionalString
      (lib.versionAtLeast kernelPackages.kernel.version "3.13")
      ''SUBSYSTEM=="pci", KERNEL=="0000:00:14.0", ATTR{power/wakeup}="disabled"'';
}
