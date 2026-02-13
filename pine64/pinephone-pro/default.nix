{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./audio.nix
    ./wifi.nix
  ];

  config = {
    nixpkgs.overlays = [
      (final: _prev: {
        pine64-alsa-ucm = final.callPackage ./pine64-alsa-ucm { };
        firmware_pinephone-pro = pkgs.callPackage ./firmware.nix { };
        linuxPackages_pinephone-pro = pkgs.callPackage ./kernel { inherit (config.boot) kernelPatches; };
      })
    ];

    hardware.firmware = [ pkgs.firmware_pinephone-pro ];

    boot = {
      kernelPackages = pkgs.linuxPackagesFor pkgs.linuxPackages_pinephone-pro;
      loader = {
        generic-extlinux-compatible.enable = true;
        grub.enable = false;
      };
    };
  };
}
