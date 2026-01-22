{ lib, config, ... }:
{
  imports = [
    ../../../../../../common/gpu/nvidia/pascal
    ../../../../../../common/gpu/nvidia/prime-sync.nix

    ../.
  ];
  hardware = {
    graphics = {
      enable = lib.mkDefault true;
      enable32Bit = lib.mkDefault true;
    };
    nvidia = {
      powerManagement.enable = lib.mkDefault true;
      modesetting.enable = lib.mkDefault true;

      dynamicBoost.enable = lib.mkForce false; # Dynamic boost is not supported on Pascal architeture
      prime = {
        # 00:02.0 VGA compatible controller: Intel Corporation CometLake-U GT2 [UHD Graphics] (rev 02)
        intelBusId = lib.mkDefault "PCI:0:2:0";
        # 2d:00.0 3D controller: NVIDIA Corporation GP108M [GeForce MX330] (rev a1)
        nvidiaBusId = lib.mkDefault "PCI:45:0:0";
      };
    };
  };
  services.thermald.enable = lib.mkDefault true;
}
