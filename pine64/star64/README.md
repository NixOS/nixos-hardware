# Creating a SD-Image

Create and configure the `flake.nix` file:

``` nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nixos-hardware.url = "github:nixos/nixos-hardware";


  outputs = { self, nixpkgs, nixos-hardware, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "riscv64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSupportedSystems = nixpkgs.lib.genAttrs supportedSystems;
    in {
      packages = forAllSupportedSystems (system: rec {
        default = sd-image;
        sd-image = (import "${nixpkgs}/nixos" {
          configuration =
            { config, ... }: {
              imports = [
                "${nixos-hardware}/pine64/star64/sd-image.nix"
                # or, for a system like an installation media:
                #"${nixos-hardware}/pine64/star64/sd-image-installer.nix"
              ];

              system.stateVersion = "23.05";
              networking.useDHCP = true;
              services.openssh.enable = true;

              users.users.nixos = {
                isNormalUser = true;
                extraGroups = [ "wheel" ];
              };
              security.sudo.wheelNeedsPassword = false;
              # Set a password
              users.users.nixos.initialPassword = "nixos";
              # OR add your public ssh key
              #users.users.nixos.openssh.authorizedKeys.keys = [ "ssh-rsa ..." ];

              sdImage.compressImage = false;

              # Set if cross compiling
              #nixpkgs.crossSystem = {
              #  config = "riscv64-unknown-linux-gnu";
              #  system = "riscv64-linux";
              #};

              # Additional configuration goes here
            };
          inherit system;
        }).config.system.build.sdImage;
      });
    };
}
```

Build the sd image.

``` sh
nix build .#
```

## Additional configuration

### 8GB memory

If your board has 8GB of RAM add the following to your config:

``` nix
hardware.deviceTree.overlays = [{
  name = "8GB-patch";
  dtsFile =
    "${nixos-hardware}/pine64/star64/star64-8GB.dts";
}];
```

# Updating the bootloader

## eMMC

Install the firmware update script

``` nix
environment.systemPackages = [
  (pkgs.callPackage
    "${nixos-hardware}/pine64/star64/firmware.nix"
    { }).updater-mmc
];
```

Then run as root

``` sh
star64-firmware-update-mmc
```

## SD-Card

Install the firmware update script

``` nix
environment.systemPackages = [
  (pkgs.callPackage
    "${nixos-hardware}/pine64/star64/firmware.nix"
    { }).updater-sd
];
```

Then run as root

``` sh
star64-firmware-update-sd
```

## SPI Flash

Install the firmware update script

``` nix
environment.systemPackages = [
  (pkgs.callPackage
    "${nixos-hardware}/pine64/star64/firmware.nix"
    { }).updater-flash
];
```

Then run as root

``` sh
star64-firmware-update-flash
```
