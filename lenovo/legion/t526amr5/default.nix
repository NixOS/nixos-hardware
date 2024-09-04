{ lib, ... }:

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/gpu/nvidia
    ../../../common/pc/ssd
  ];

  # TPM2 module
  security.tpm2.enable = true;

  # Device could have multiple architectures, but they all support open
  hardware.nvidia.open = true;
}
