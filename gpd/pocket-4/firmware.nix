{ pkgs, ... }:
let
  lfw = "${pkgs.linux-firmware}/lib/firmware";
in
pkgs.stdenv.mkDerivation {
  name = "gpd-pocket-4-firmware";
  phases = [ "installPhase" ];
  # Wide net for amdgpu/amdtee to support non-370 CPU models I can't test.
  installPhase = ''
    mkdir -p $out/lib/firmware/intel $out/lib/firmware/rtl_nic
    cp -r \
      ${lfw}/amdgpu \
      ${lfw}/amdtee \
      ${lfw}/iwlwifi-ty-a0-gf-a0* \
      $out/lib/firmware/
    cp ${lfw}/intel/ibt-0041-0041.sfi $out/lib/firmware/intel/
    cp ${lfw}/rtl_nic/rtl8125b-2.fw $out/lib/firmware/rtl_nic/
  '';
}
