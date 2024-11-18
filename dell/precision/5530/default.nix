{ lib, config, ... }:

{
  imports = [
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
    ../../../common/gpu/nvidia/pascal
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/cpu/intel/coffee-lake
  ];

  boot = {
    kernelParams = [
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
      "nvidia_drm.modeset=1"
    ];
  };

  hardware = {
    nvidia = {
      open = lib.mkDefault false;
      nvidiaSettings = lib.mkDefault true;
      modesetting.enable = lib.mkDefault true;
      package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        intelBusId = lib.mkDefault "PCI:0:2:0";
        nvidiaBusId = lib.mkDefault "PCI:1:0:0";
      };
    };
  };
  # This will save you money and possibly your life!
  services = {
    fwupd.enable = lib.mkDefault true;
    thermald.enable = lib.mkDefault true;
  };
}
