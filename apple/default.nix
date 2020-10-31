{ config, lib, ... }:

{
  boot.kernelParams = [
    "hid_apple.swap_opt_cmd=1"
    "hid_apple.iso_layout=0"
  ];

  hardware.facetimehd.enable = lib.mkDefault
    (config.nixpkgs.config.allowUnfree or false);

  services.mbpfan.enable = lib.mkDefault true;
}
