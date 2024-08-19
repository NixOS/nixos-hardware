{ pkgs, lib, ... }:
let
  linux_5_15_helios4 = pkgs.linux_5_15.override {
    kernelPatches = [
      # A patch to get both PWM fans working
      # the patch has been successfully applied to 5.15 and 5.19
      {
        patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/armbian/build/bd3466eef2106ea13e85e821f5d852ff97465e6c/patch/kernel/archive/mvebu-5.15/92-mvebu-gpio-remove-hardcoded-timer-assignment.patch";
          sha256 = "sha256-eQqMp0+MZd30zkl8DE89oB7czvyqCkfwF2k0EZ69jr0=";
        };
      }
      # support for Wake-On-Lan
      {
        patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/armbian/build/bd3466eef2106ea13e85e821f5d852ff97465e6c/patch/kernel/archive/mvebu-5.15/92-mvebu-gpio-add_wake_on_gpio_support.patch";
          sha256 = "sha256-OrvnVCU55P0U78jdoxGRJvl29i+Rvq8AdEGSCCpxa2I=";
        };
      }
      {
        patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/armbian/build/bd3466eef2106ea13e85e821f5d852ff97465e6c/patch/kernel/archive/mvebu-5.15/94-helios4-dts-add-wake-on-lan-support.patch";
          sha256 = "sha256-ai4161bTC22023eaVVWsvbk6fQKjkv0P4DQ4DA1Zgow=";
        };
      }
    ];
    defconfig = "mvebu_v7_defconfig";
    # Make the kernel build a bit faster by disabling GPU modules, which we don't need anyways
    structuredExtraConfig = {
      DRM = lib.mkForce pkgs.lib.kernel.no;
    };
  };
in
{
  imports = [ ./modules/fancontrol.nix ];

  nixpkgs.overlays = [ (import ./overlay.nix) ];

  nixpkgs.hostPlatform = "armv7l-linux";

  boot.initrd.availableKernelModules = [ "ahci_mvebu" ];

  boot.kernelPackages = pkgs.linuxPackagesFor linux_5_15_helios4;
}
