{ lib, ... }:

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/gpu/nvidia
    ../../../common/pc/ssd
  ];

  # TPM2 module
  security.tpm2.enable = true;
}
