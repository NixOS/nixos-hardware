{
  lib,
  stdenv,
  callPackages,
}:
let
  pkgs = callPackages ./. { };
in
lib.optionalAttrs (stdenv.hostPlatform.isx86_64) {
  kernel-stable = pkgs.kernel-stable.kernel;
  kernel-longterm = pkgs.kernel-longterm.kernel;
}
