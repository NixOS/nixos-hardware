# Creating an installation SD card image

Create and customize a `flake.nix` file:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { nixpkgs, nixos-hardware, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "riscv64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSupportedSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSupportedSystems (system: rec {
        default = sd-image;
        sd-image = (import "${nixpkgs}/nixos" {
          configuration = {
            imports = [
              "${nixos-hardware}/orange-pi/5-max/sd-image-installer.nix"
            ];

            nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
              "orangepi-firmware"
              "mali-g610-firmware"
            ];

            # If you want to use ssh set a password
            # users.users.nixos.password = "super secure password";
            # OR add your public ssh key
            # users.users.nixos.openssh.authorizedKeys.keys = [ "ssh-rsa ..." ];

            nixpkgs.buildPlatform.system = system;
            nixpkgs.hostPlatform.system = "aarch64-linux";

            system.stateVersion = "24.11";
          };
          inherit system;
        }).config.system.build.sdImage;
      });
    };
}
```

Then build the image by running `nix build .#` in the same folder.

## Flashing image
Replace `/dev/sdX` with the device name of your sd card.
```sh
zstdcat result/sd-image/nixos-sd-image-*-orange-pi-5-max.img.zst | sudo dd status=progress bs=8M of=/dev/sdX
```

# Updating the bootloader
Install the enable the update scripts
```nix
hardware.orange-pi."5-max".uboot.updater.enable = true;
```

uart debugging options are applied to the bootloader installed by the firmware update script
```nix
hardware.orange-pi."5-max".uartDebug = {
  enable = true; # enabled by default for debugging
  baudRate = 57600; # default is 1500000
};
```

## SD-Card
Run as root
``` sh
orangepi5max-firmware-update-sd
```
## SPI Flash
Run as root
``` sh
orangepi5max-firmware-update-flash
```
