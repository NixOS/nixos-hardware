{ lib, ... }:

let
  inherit (lib) mkOption types;

in {
  imports = [
    ./linux-6.10.x
    ./linux-6.11.x
  ];

  options.microsoft-surface.kernelVersion = mkOption {
    description = "Kernel Version to use (patched for MS Surface)";
    type = types.enum [ ];
  };
}
