{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../../../../common/cpu/amd
      ../../../../common/cpu/amd/pstate.nix
      ../../../../common/gpu/amd
      ../../../../common/pc/laptop
      ../../../../common/pc/laptop/acpi_call.nix
      ../../../../common/pc/laptop/ssd
    ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  boot.kernelModules = [ "synaptics_usb" ];
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;

  # disable Scatter/Gather APU recently enabled by default,
  # which results in white screen after display reconfiguration
  boot.kernelParams = [ "amdgpu.sg_display=0" ];

  services.xserver = {
    videoDrivers = [ "amdgpu" ];
  };
}
