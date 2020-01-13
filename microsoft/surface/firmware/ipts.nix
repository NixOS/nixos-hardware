{stdenv, pkgs}:
stdenv.mkDerivation {
  name = "microsoft-surface-ipts-firmware";
  src = ./intel/ipts;
  priority = 1;
  installPhase = ''
    mkdir -p $out/lib/firmware/intel/ipts
    cp -r $src/* $out/lib/firmware/intel/ipts
  '';
}
