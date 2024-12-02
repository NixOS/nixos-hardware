{ pkgs, lib, ... }:

{
  imports =
    [
      ../../../../common/cpu/amd
      ../../../../common/cpu/amd/pstate.nix
      ../../../../common/gpu/amd
      ../../../../common/pc/laptop
      ../../../../common/pc/laptop/ssd
    ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  boot.kernelModules = [ "synaptics_usb" ];
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.3") (lib.mkDefault pkgs.linuxPackages_latest);

  # disable Scatter/Gather APU recently enabled by default,
  # which results in white screen after display reconfiguration
  boot.kernelParams = [ "amdgpu.sg_display=0" ];

  services.xserver = {
    videoDrivers = [ "amdgpu" ];
  };
}
