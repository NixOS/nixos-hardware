## Build the SD image
- ``nix-build "<nixpkgs/nixos>" -A config.system.build.sdImage -I nixos-config=iso.nix``

- ``iso.nix``
    ```nix
    { config, ... }:

    {
        imports = [ <nixos-hardware/starfive/visionfive/v1/sd-image-installer.nix> ];
        # or imports = [ "${nixos-hardware-directory}/starfive/visionfive/v1/sd-image-installer.nix" ];

        nixpkgs.crossSystem = {
            config = "riscv64-unknown-linux-gnu";
            system = "riscv64-linux";
        };
    }
    ```

## Relevant documentation
- Flashing
  - https://doc-en.rvspace.org/VisionFive/Quick_Start_Guide/VisionFive_QSG/hardware_connection.html
  - https://doc-en.rvspace.org/VisionFive/Quick_Start_Guide/VisionFive_QSG/using_xmodem1.html
- Recovery
  - https://doc-en.rvspace.org/VisionFive/Quick_Start_Guide/VisionFive_QSG/hardware_setup.html
  - https://doc-en.rvspace.org/VisionFive/Quick_Start_Guide/VisionFive_QSG/for_maclinux4.html
