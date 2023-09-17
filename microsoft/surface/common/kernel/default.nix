{ lib, ... }:

let
  inherit (lib) mkOption types;

in {
  imports = [
    ./linux-6.1.53
    ./linux-6.4.16
  ];

  options.microsoft-surface.kernelVersion = mkOption {
    description = "Kernel Version to use (patched for MS Surface)";
    type = types.enum [ ];
  };
}
