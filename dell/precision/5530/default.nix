{ lib, ...}:

{
  imports = [
    ../../../common/cpu/intel/coffee-lake
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
    ../../../common/gpu/nvidia/pascal
    ../../../common/gpu/nvidia/prime.nix
  ];

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
  hardware.nvidia = {
    open = lib.mkDefault true;
    nvidiaSettings = lib.mkDefault true;
    package = "config.boot.kernelPackages.nvidiaPackages.stable";
    modesetting.enable = lib.mkDefault true;
    prime = {
      # Bus ID of the Intel GPU.
      intelBusId = lib.mkDefault "PCI:0:2:0";

      # Bus ID of the NVIDIA GPU.
      nvidiaBusId = lib.mkDefault "PCI:1:0:0";
    };
  };
  # This will save you money and possibly your life!
  services = {
    thermald.enable = lib.mkDefault true;
    fwupd.enable = lib.mkDefault true;
  };
  # so that post-resume.service exists
  powerManagement.enable = true;
}
