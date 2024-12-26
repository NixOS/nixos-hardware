/*
 * `lenovo-yoga-7-14IAH7-hybrid`:
 *
 * This is a hybrid profile that enables the NVIDIA
 * driver and PRIME offload mode for making use of both
 * integrated and dedicated graphics. Use this profile if
 * you want to use the NVIDIA GeForce RTX 3050 Mobile.
 * Read about PRIME offload mode here:
 * <https://wiki.nixos.org/wiki/NVIDIA#Offload_mode>
 *
 * The `lenovo-yoga-7-14IAH7-integrated` profile only
 * has the integrated Intel GPU enabled. The dedicated
 * NVIDIA GPU is disabled entirely. Use that profile
 * instead if you want to only use integrated graphics.
 *
 * `nouveau` wasn't added to any profiles since it
 * is known to cause freezes for this device.
 * `nouveau` is blacklisted by default when enabling this:
 * <https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/hardware/video/nvidia.nix>
 */
{ lib, ... }:
{
  imports = [
    ../shared.nix
    ../../../../../common/gpu/nvidia/ampere
    ../../../../../common/gpu/nvidia/prime.nix
  ];

  hardware.nvidia = {
    # Info: <https://wiki.nixos.org/wiki/NVIDIA#Common_setup>
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    # Info: <https://download.nvidia.com/XFree86/Linux-x86_64/460.73.01/README/dynamicpowermanagement.html>
    powerManagement.enable = lib.mkDefault true;
  };
}
