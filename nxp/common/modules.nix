{ pkgs, lib, ... }: {
  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  boot = {
    kernelPackages = pkgs.linuxPackagesFor pkgs.linux_imx8;
    kernelParams = [ "console=ttyLP0,115200n8" ];
    loader.grub.enable = lib.mkDefault true;
    initrd.includeDefaultModules = lib.mkForce false;
  };

  disabledModules = [ "profiles/all-hardware.nix" ];

  hardware.deviceTree.enable = true;
}
