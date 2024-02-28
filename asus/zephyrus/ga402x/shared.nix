{ config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkDefault mkIf mkMerge version versionOlder;
in {

  imports = [
    ../../../common/cpu/amd
    # Better power-savings from AMD PState:
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/pc/laptop
    ../../../common/pc/laptop/acpi_call.nix
    ../../../common/pc/ssd
  ];

  config = mkMerge [
    {
      # Configure basic system settings:
      boot = {
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

        supergfxd.enable = true;

        udev = {
          extraHwdb = ''
            # Fixes mic mute button
            evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
            KEYBOARD_KEY_ff31007c=f20
          '';
          extraRules = ''
            # Disable auto-suspend for the ASUS N-KEY Device, i.e. USB Keyboard
            # Otherwise, it will tend to take 1-2 key-presses to wake-up after suspending
            ACTION=="add", SUBSYSTEM=="usb", TEST=="power/autosuspend", ATTR{idVendor}=="0b05", ATTR{idProduct}=="19b6", ATTR{power/autosuspend}="-1"
          '';
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
