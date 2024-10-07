{ pkgs, lib, ... }: let inherit(lib) mkDefault; in {
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../../common/gpu/intel/meteor-lake
  ];

  # Allows for updating firmware via `fwupdmgr`.
  services.fwupd.enable = mkDefault true;

  # This will save you money and possibly your life!
  services.thermald.enable = mkDefault true;

  hardware.intelgpu.deviceID = "7d55";
}
