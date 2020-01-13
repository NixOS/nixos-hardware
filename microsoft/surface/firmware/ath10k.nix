{stdenv, pkgs}:
stdenv.mkDerivation {
  name = "microsoft-surface-ath10k-firmware";
  src = ./ath10k;
  priority = 1;
  installPhase = ''
    mkdir -p $out/lib/firmware/ath10k
    cp -r $src/* $out/lib/firmware/ath10k
  '';
}
