{ pkgs, lib, ... }:
let
  linux_6_18_helios4 = pkgs.linux_6_18.override {
    kernelPatches = [
      # Let both PWM fans share a GPIO bank
      {
        name = "mvebu-gpio-multi-pwm-per-bank";
        patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/armbian/build/309b2244455dca3acc9a7004d92e6781b539d50c/patch/kernel/archive/mvebu-6.18/92-mvebu-gpio-multi-pwm-per-bank.patch";
          hash = "sha256-UsZFNE1idg+uqsNbrjhkCXC1WFh7KRL22yZRdVKdQGs=";
        };
      }
      # support for Wake-On-Lan
      {
        name = "mvebu-gpio-add-wake-on-gpio-support";
        patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/armbian/build/309b2244455dca3acc9a7004d92e6781b539d50c/patch/kernel/archive/mvebu-6.18/92-mvebu-gpio-add_wake_on_gpio_support.patch";
          hash = "sha256-3hNTpYwdCu1s7O6QooUgPx4C+5P1lMvphkiMI+RKIy8=";
        };
      }
      {
        name = "helios4-dts-add-wake-on-lan-support";
        patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/armbian/build/309b2244455dca3acc9a7004d92e6781b539d50c/patch/kernel/archive/mvebu-6.18/94-helios4-dts-add-wake-on-lan-support.patch";
          hash = "sha256-PFX9kDMnW86ADztXgQgO7zgw5GSiSYl4WOYjzRAZqUg=";
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

  nixpkgs.hostPlatform.system = "armv7l-linux";

  boot.initrd.availableKernelModules = [ "ahci_mvebu" ];

  boot.kernelPackages = pkgs.linuxPackagesFor linux_6_18_helios4;
}
