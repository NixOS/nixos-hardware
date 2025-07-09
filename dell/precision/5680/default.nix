{
  lib,
  ...
}:
{
  imports = [
    ../../../common/hidpi.nix
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../../common/cpu/intel/raptor-lake
    ../../../common/gpu/nvidia/ada-lovelace
    ../../../common/gpu/nvidia/prime.nix
  ];

  hardware = {
    # Audio
    enableRedistributableFirmware = lib.mkDefault true;

    # Webcam
    ipu6 = {
      enable = lib.mkDefault true;
      platform = lib.mkDefault "ipu6ep";
    };

    bluetooth = {
      enable = lib.mkDefault true;
      powerOnBoot = lib.mkDefault true;
    };

    graphics.enable = lib.mkDefault true;

    nvidia = {
      modesetting.enable = lib.mkDefault true;
      nvidiaSettings = lib.mkDefault true;

      powerManagement = {
        enable = lib.mkDefault true;
        finegrained = lib.mkDefault true;
      };

      prime = {
        intelBusId = lib.mkDefault "PCI:00:02:0";
        nvidiaBusId = lib.mkDefault "PCI:01:00:0";
      };
    };
  };

  services = {
    fwupd.enable = lib.mkDefault true; # update firmware
    hardware.bolt.enable = lib.mkDefault true; # use thunderbolt
    pcscd.enable = lib.mkDefault true; # card reader
    thermald.enable = lib.mkDefault true; # fans
  };

}
