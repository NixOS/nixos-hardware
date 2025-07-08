{ lib, ... }:
{
  imports = [
    ../shared.nix
    ../../../../common/gpu/nvidia/pascal
    ../../../../common/gpu/nvidia/prime.nix
  ];

  hardware.nvidia = {
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };

    dynamicBoost.enable = lib.mkForce false; # Dynamic boost is not supported on Pascal architeture
  };
}
