{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../../../../common/gpu/nvidia/prime.nix
    ../../../../../common/gpu/nvidia/turing
    ../../../../../common/cpu/intel/tiger-lake
    ../.
  ];

  # For suspending to RAM to work, set Config -> Power -> Sleep State to "Linux S3" in EFI.

  hardware = {
    enableAllFirmware = lib.mkDefault true;

    graphics = {
      enable = lib.mkDefault true;
      enable32Bit = lib.mkDefault true;
    };

    intelgpu.driver = "xe";

    nvidia = {
      modesetting.enable = lib.mkDefault true;

      # Enable power management to fix suspend/resume screen corruption in sync mode
      powerManagement = {
        enable = lib.mkDefault false;
        finegrained = lib.mkDefault false;
      };

      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  # Force use of the thinkpad_acpi driver for backlight control
  boot.kernelParams = [ "acpi_backlight=vendor" ];

  services.thermald.enable = lib.mkDefault true;
}
