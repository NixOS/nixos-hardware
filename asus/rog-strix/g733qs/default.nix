{ pkgs, lib, ... }:
{
  imports = [
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/ampere
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../battery.nix
  ];

  # fixing audio by overriding pins as suggested in
  # https://www.reddit.com/r/ASUS/comments/mfokva/asus_strix_scar_17_g733qs_and_linux/
  hardware.firmware = [
    (pkgs.runCommand "jack-retask" { } ''
      install -D ${./hda-jack-retask.fw} $out/lib/firmware/hda-jack-retask.fw
    '')
  ];
  boot.extraModprobeConfig = ''
    options snd-hda-intel patch=hda-jack-retask.fw
  '';
  # before 5.12 it would interpret every keystroke as the power button
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.12") (lib.mkDefault pkgs.linuxPackages_latest);

  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:5:0:0";
    nvidiaBusId = "PCI:1:0:1";
  };
}
