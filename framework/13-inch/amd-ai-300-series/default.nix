{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../common
    ../common/amd.nix
  ];
  config.hardware.framework.laptop13.audioEnhancement.rawDeviceName =
    lib.mkDefault "alsa_output.pci-0000_c1_00.6.analog-stereo";
}
