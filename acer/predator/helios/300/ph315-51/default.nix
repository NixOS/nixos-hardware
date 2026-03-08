{
  lib,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  imports = [
    ../../../../../common/pc/laptop
    ../../../../../common/cpu/intel/coffee-lake
    ../../../../../common/gpu/nvidia/pascal
  ];

  hardware = {
    nvidia = {
      modesetting.enable = mkDefault true;

      prime = {
        sync.enable = mkDefault true;
        intelBusId = "PCI:0@0:2:0";
        nvidiaBusId = "PCI:1@0:0:0";
      };
    };
  };
}
