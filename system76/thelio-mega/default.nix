# Hardware profile for the Thelio Mega desktop workstation by System76.
#
# https://system76.com/desktops/thelio-mega-r4-n3/configure
{
  config,
  lib,
  ...
}:
{
  imports = [
    ../../common/cpu/amd
    ../../common/gpu/nvidia
  ];

  hardware.nvidia.open = true;
}
