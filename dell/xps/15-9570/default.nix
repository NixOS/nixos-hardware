{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
  ];

  # TODO: boot loader
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  nix.buildCores = lib.mkDefault 12;

  # Recommended in Arch wiki, avoids shutdowns
  boot.kernelParams = [
    "mem_sleep_default=deep"
    "nouveau.blacklist=0"
    "acpi_osi=!"
    "acpi_osi=\"Windows 2015\""
    "acpi_backlight=vendor"
  ];

  # To just use Intel integrated graphics with Intel's open source driver
  # hardware.nvidiaOptimus.disable = true;

  # To setup proprietary NVIDIA Optimus properly.
  # boot.blacklistedKernelModules = [ "nouveau" "nv" "rivafb" "nvidiafb" "rivatv" ];
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia.optimus_prime.enable = true;
  # hardware.nvidia.modesetting.enable = true;

  # This should be the same for all XPS 9570 models with NVIDIA
  hardware.nvidia.optimus_prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}
