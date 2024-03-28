{ config, lib, ... }: {
  imports = [
    ../intel
    ../../yoga.nix
  ];

  services.xserver.wacom.enable = lib.mkDefault config.services.xserver.enable;
}
