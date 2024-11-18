{ config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkDefault mkEnableOption mkIf mkMerge mkForce version versionAtLeast versionOlder;
in {

  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/pc/laptop
    ../../../common/pc/laptop/acpi_call.nix
    ../../../common/pc/ssd
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/ada-lovelace
  ];

  config = mkMerge [
    {
      # Configure basic system settings:
      boot = {
        kernelPackages = mkDefault pkgs.linuxPackages_latest;
        kernelModules = [ "kvm-amd" ];
        kernelParams = [
          "mem_sleep_default=deep"
          "pcie_aspm.policy=powersupersave"
        ];
      };

      services = {
        asusd = {
          enable = mkDefault true;
          enableUserService = mkDefault true;
        };

        supergfxd.enable = mkDefault true;
      };

      # Enable the Nvidia card, as well as Prime and Offload: NVIDIA GeForce RTX 4060 Mobile
      boot.blacklistedKernelModules = [ "nouveau" ];

      services.xserver.videoDrivers = mkForce [ "amdgpu" "nvidia" ];

      hardware = {
        amdgpu.initrd.enable = mkDefault true;

        nvidia = {
          modesetting.enable = true;
          nvidiaSettings = mkDefault true;

          prime = {
            offload = {
              enable = mkDefault true;
              enableOffloadCmd = mkDefault true;
            };
            amdgpuBusId = "PCI:101:0:0";
            nvidiaBusId = "PCI:1:0:0";
          };

          powerManagement = {
            enable = true;
            finegrained = true;
          };
        };
      };
    }

    (mkIf (versionOlder version "23.11") {
      # See https://asus-linux.org/wiki/nixos/ for info about some problems
      # detecting the dGPU:
      systemd.services.supergfxd.path = [ pkgs.pciutils ];
    })

    (mkIf (config.networking.wireless.iwd.enable && config.networking.wireless.scanOnLowSignal) {
      # Meditek doesn't seem to be quite sensitive enough on the default roaming settings:
      #   https://wiki.archlinux.org/title/Wpa_supplicant#Roaming
      #   https://wiki.archlinux.org/title/Iwd#iwd_keeps_roaming
      #
      # But NixOS doesn't have the tweaks for IWD, yet.
      networking.wireless.iwd.settings = {
        General = {
          RoamThreshold = -75;
          RoamThreshold5G = -80;
          RoamRetryInterval = 20;
        };
      };
    })
  ];
}
