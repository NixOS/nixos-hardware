{ ... }:

# This module is intended to support the Surface Laptop range, specifically those with AMD CPUs.
# It's expected it will work equally well on many other Surface models, but they may need further
# config changes to work well.

{
  imports = [
    ../common
    ../../../common/pc
    ../../../common/pc/ssd
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
  ];

  # Note: The IPTS module is not often required on devices with Surface Laptop 3 (AMD).
  microsoft-surface.ipts.enable = true;
  microsoft-surface.surface-control.enable = true;
}
