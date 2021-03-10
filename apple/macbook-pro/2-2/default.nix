{ lib, config, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/pc/laptop/hdd
    ../../../common/pc/uefi32
  ];

  # TODO:
  #  - [ ] build kernel with radeon vbios loading support
  #  - [ ] put firmware in the right place
  #  [[https://bbs.archlinux.org/viewtopic.php?pid=1810437#p1810437][Load custom Radeon firmware for Macbook Pro / Kernel & Hardware / Arch Linux Forums]]
  boot.kernelParams = ["nomodeset"];
}
