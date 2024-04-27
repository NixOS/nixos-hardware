{ config, lib, pkgs, ... }: {
  imports = [
    ../../../common/cpu/intel
  ];

  boot.kernelParams = [    
    # For Power consumption
    # https://community.frame.work/t/linux-battery-life-tuning/6665/156
    "nvme.noacpi=1"
  ] 
  # Fixes a regression in s2idle, making it more power efficient than deep sleep
  # Update 04/2024: It appears that s2idle-regression got fixed in newer kernel-versions (SebTM)
  # (see: https://github.com/NixOS/nixos-hardware/pull/903#discussion_r1556096657)
  ++ lib.lists.optional (lib.versionOlder config.boot.kernelPackages.kernel.version "6.8") "acpi_osi=\"!Windows 2020\"";

  # Requires at least 5.16 for working wi-fi and bluetooth.
  # https://community.frame.work/t/using-the-ax210-with-linux-on-the-framework-laptop/1844/89
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.16") (lib.mkDefault pkgs.linuxPackages_latest);

  # Module is not used for Framework EC but causes boot time error log.
  boot.blacklistedKernelModules = [ "cros-usbpd-charger" ];

  # Custom udev rules
  services.udev.extraRules = ''
    # Fix headphone noise when on powersave
    # https://community.frame.work/t/headphone-jack-intermittent-noise/5246/55
    SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0xa0e0", ATTR{power/control}="on"
  '';

  # Mis-detected by nixos-generate-config
  # https://github.com/NixOS/nixpkgs/issues/171093
  # https://wiki.archlinux.org/title/Framework_Laptop#Changing_the_brightness_of_the_monitor_does_not_work
  hardware.acpilight.enable = lib.mkDefault true;

  # This adds a patched ectool, to interact with the Embedded Controller
  # Can be used to interact with leds from userspace, etc.
  # Not part of a nixos release yet, so package only gets added if it exists.
  environment.systemPackages = lib.optional (pkgs ? "fw-ectool") pkgs.fw-ectool;

}
