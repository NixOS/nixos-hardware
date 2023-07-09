{ lib, pkgs, ... }: {
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # Allows for updating firmware via `fwupdmgr`.
  services.fwupd.enable = true;
}
