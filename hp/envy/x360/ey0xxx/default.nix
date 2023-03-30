{ config, lib, ... }:
with lib;
{
  config = {
      boot.kernelPatches = [
        {
          name = "hp-envy-x360-ey0xxx-speaker";
          patch = ./speaker.patch;
        }
      ];
  };
}
