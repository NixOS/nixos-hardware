{ lib, ... }:

{
  boot.blacklistedKernelModules = lib.mkDefault [ "i915" ];
  # KMS will load the module, regardless of blacklisting
  boot.kernelParams = lib.mkDefault [ "i915.modeset=0" ];
}
