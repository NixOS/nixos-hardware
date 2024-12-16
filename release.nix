let
  lib = import <nixpkgs/lib>;
  pkgsFor.aarch64-linux = import <nixpkgs> {
    system = "aarch64-linux";
  };
in
{
  linux_rpi5.aarch64-linux =
    (
      import ./raspberry-pi/5/packages.nix {
        inherit lib;
        pkgs = pkgsFor.aarch64-linux;
      }
    ).linux_rpi5;
}
