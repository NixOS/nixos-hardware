{ lib, ... }:

{
  imports = [
    ./intel
  ];

  # Boot loader
  boot.kernelParams = [
    # fix lspci hanging with nouveau
    # source https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1803179/comments/149
    "acpi_rev_override=1"
    "acpi_osi=Linux"
    "nouveau.modeset=0"
    "pcie_aspm=force"
    "drm.vblankoffdelay=1"
    "nouveau.runpm=0"
    "mem_sleep_default=deep"
    # fix flicker
    # source https://wiki.archlinux.org/index.php/Intel_graphics#Screen_flickering
    "i915.enable_psr=0"
  ];

  boot.kernelModules = lib.mkDefault [ "kvm-intel" ];

  # Recommended in NixOS/nixos-hardware#127
  services.thermald.enable = lib.mkDefault true;
}
