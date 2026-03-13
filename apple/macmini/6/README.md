# macmini 6.1/6.2

Everything should be working flawlessly **except** the wifi card which is not included in this config for performance and security reason.

Here is the potential fix you can use for this :
- enable the b43 driver (it work but wifi performance are terrible)
```nix
  boot = {
    kernelModules = [
      "b43"
    ];
    blacklistedKernelModules = [
      "wl"
      "bcma"
    ];
  };
  networking.enableB43Firmware = true;
```
- enable the insecure broadcom_sta driver
```nix
  nixpkgs.config.allowInsecurePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "broadcom-sta" # aka “wl”
    ];
  boot = {
    kernelModules = [
      "wl"
    ];
    blacklistedKernelModules = [
      "b43"
      "bcma"
    ];
    extraModulePackages = [
      # install broadcom driver for macos wifi
      # note : the user will need to add it to `permittedInsecurePackages`
      config.boot.kernelPackages.broadcom_sta
    ];
  };
```
