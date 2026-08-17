# Flag values from drivers/gpu/drm/amd/include/amd_shared.h
{ config, lib, ... }:
let
  flags = {
    disablePipeSplit = 1;
    disableStutter = 2;
    disableDsc = 4;
    disableClockGating = 8;
    disablePsr = 16;
    disableMpo = 64;
    disablePsrSu = 512;
    disableReplay = 1024;
    disableIps = 2048;
  };

  cfg = config.hardware.amdgpu.dcDebugMask;

  mask = lib.foldlAttrs (
    acc: name: bit:
    if cfg.${name} then lib.bitOr acc bit else acc
  ) 0 flags;
in
{
  options.hardware.amdgpu.dcDebugMask = lib.mapAttrs (
    _name: bit:
    lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Set flag 0x${lib.toHexString bit} in amdgpu.dcdebugmask.";
    }
  ) flags;

  config = lib.mkIf (mask != 0) {
    boot.kernelParams = [ "amdgpu.dcdebugmask=0x${lib.toHexString mask}" ];
  };
}
