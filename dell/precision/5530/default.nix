{ lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  # https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1803179/comments/149
  # fix lspci hanging with nouveau
  boot.kernelParams = [
    "acpi_rev_override=1"
    "acpi_osi=Linux"
    "nouveau.modeset=0"
    "pcie_aspm=force"
    "drm.vblankoffdelay=1"
    "scsi_mod.use_blk_mq=1"
    "nouveau.runpm=0"
    "mem_sleep_default=deep"
  ];
}
