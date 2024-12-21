/*
 * #######################################
 * NVIDIA GeForce RTX 3050 Mobile (Ampere)
 * #######################################
 * This enables the NVIDIA driver and PRIME offload mode.
 *
 * This is for the NVIDIA GeForce RTX 3050 Mobile (Ampere) that
 * Lenovo Slim Yoga 7 laptops have.
 *
 * Either `hardware.nvidia.prime.amdgpuBusId` or
 * `hardware.nvidia.prime.intelBusId` should be set for it to work.
 * This is set by the importing `lenovo-yoga-7-14ARH7-nvidia` and
 * `lenovo-yoga-7-14IAH7-nvidia` profiles.
 *
 * `nouveau` is blacklisted by default when enabling this:
 * <https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/hardware/video/nvidia.nix>
 */
{ lib, ... }:
{
  imports = [
    # Standard set-up is configured here:
    ../../../../../../common/gpu/nvidia/ampere
    # PRIME offload mode is configured here:
    ../../../../../../common/gpu/nvidia/prime.nix
  ];

  hardware = {
    nvidia = {
      # Info: <https://wiki.nixos.org/wiki/NVIDIA#Common_setup>
      prime.nvidiaBusId = "PCI:1:0:0";

      powerManagement = {
        enable = lib.mkDefault true;
        # Doesn't seem to be reliable, yet?
        # finegrained = true
      };
    };
  };
}
