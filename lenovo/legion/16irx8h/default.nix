{
  lib,
  config,
  ...
}:
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/ada-lovelace
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../../common/hidpi.nix
  ];

  boot.initrd.kernelModules = [ "nvidia" ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.lenovo-legion-module
    config.boot.kernelPackages.nvidia_x11
  ];

  # Comprehensive audio fixes for Legion Pro 7 16IRX8H
  # This model has both Realtek ALC287 and TAS2781 audio components
  # The TAS2781 I2C codec binds to the HDA subsystem and requires special handling
  boot.kernelParams = [
    # Audio configuration
    "snd_hda_intel.enable_msi=1"
    # Legion-specific audio model (required until kernel quirk is upstreamed)
    "snd_hda_intel.model=legion-y7000"
    # TAS2781 calibration reset to handle CRC errors in factory calibration data
    # This is a known issue on Legion laptops where the TAS2781 firmware has corrupted
    # calibration values; resetting allows the codec to initialize with defaults
    "snd_soc_tas2781.reset_calib=1"
    # Hardware fixes
    "tsc=reliable" # Fix TSC ADJUST firmware bugs common on Legion laptops
    # ACPI thermal management fixes for Legion BIOS issues
    "acpi.debug_layer=0x2"
    "acpi.debug_level=0x2"
    "processor.ignore_ppc=1"
  ];

  # Additional audio configuration for Legion Pro 7
  boot.extraModprobeConfig = ''
    # Force specific Legion audio model for proper speaker routing
    options snd-hda-intel model=lenovo-legion-7i
  '';

  # Hardware firmware support for Legion audio
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # Enable Bluetooth modules
  boot.kernelModules = [
    "bluetooth"
    "btusb"
  ];

  hardware = {
    nvidia = {
      modesetting.enable = lib.mkDefault true;
      powerManagement.enable = lib.mkDefault true;
      prime = {
        intelBusId = "PCI:00:02:0";
        nvidiaBusId = "PCI:01:00:0";
      };
    };

    # Enable Bluetooth with Legion-optimized settings
    bluetooth = {
      enable = lib.mkDefault true;
      powerOnBoot = lib.mkDefault false; # Save battery
      settings = {
        General = {
          ControllerMode = "dual";
          FastConnectable = "true";
          Experimental = "true"; # Enable LE Audio features
          KernelExperimental = "true"; # Enable ISO socket support
        };
      };
    };
  };

  # Cooling management for Legion laptops
  services.thermald.enable = lib.mkDefault true;

  # Audio group permissions
  users.groups.audio = { };

  # √(2560² + 1600²) px / 16 in ≃ 189 dpi
  services.xserver.dpi = 189;
}
