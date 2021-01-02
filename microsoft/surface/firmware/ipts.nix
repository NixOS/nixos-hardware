{ stdenv, pkgs }:
let
  repos = (pkgs.callPackage ../repos.nix {});
in
stdenv.mkDerivation {
  name = "microsoft-surface-ipts-firmware";
  src = repos.surface-ipts-firmware;
  priority = 1;
  installPhase = ''
    mkdir -p $out/lib/firmware/intel/ipts
    cp -r $src/firmware/intel/ipts/* $out/lib/firmware/intel/ipts
  '';
}
