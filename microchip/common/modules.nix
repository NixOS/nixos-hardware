{ pkgs, lib, ... }: {
  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  boot = {
    kernelPackages = pkgs.linuxPackagesFor pkgs.linux-icicle-kit;
    initrd.includeDefaultModules = lib.mkForce false;
  };

}
