# Standalone flash bundle for arduino-flasher-cli (boot / EDL payloads only).
# Layout matches qualcomm/qrb2210/arduino-image-output.nix → arduino-images/flash/
{ pkgs }:

let
  bootDrv = (pkgs.callPackage ./qrb2210-boot.nix { }).qrb2210-boot;
  qcombin = pkgs.callPackage ./qrb2210-qcombin.nix { };
in
{
  arduino-uno-q-boot = pkgs.runCommand "arduino-uno-q-boot" { } ''
    mkdir -p $out/arduino-images/flash

    cp -a ${qcombin}/share/qcombin/Agatti/arduino-uno-q/. $out/arduino-images/flash/
    chmod -R u+w $out/arduino-images/flash
    cp -f ${qcombin}/share/qcombin/Agatti/prog_firehose_ddr.elf $out/arduino-images/flash/
    cp -f ${bootDrv}/boot.img $out/arduino-images/flash/boot.img
  '';
}
