 { config, lib, pkgs, ... }:
 
 let
   inherit (lib) mkIf mkOption;
 
   inherit (pkgs.callPackage ../linux-package.nix { }) linuxPackage surfacePatches isVersionOf versionsOfEnum;
 
   cfg = config.microsoft-surface;
 
   version = "6.11.3";
   kernelPatches = surfacePatches {
     inherit version;
     patchFn = ./patches.nix;
   };
   kernelPackages = linuxPackage {
     inherit version kernelPatches;
     hash = "sha256-MJCesuBDTc6XqTzZftDfq3aIoSS8Prw+z2x3beCczAs=";
     ignoreConfigErrors=true;
   };
 
 in {
   options.microsoft-surface.kernelVersion = mkOption {
     type = versionsOfEnum version;
   };
 
   config = mkIf (isVersionOf cfg.kernelVersion version) {
     boot = {
       inherit kernelPackages;
     };
   };
 }
