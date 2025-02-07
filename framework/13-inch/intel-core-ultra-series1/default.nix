{ config, lib, pkgs, ... }:

{
  imports = [
    ../common
    ../common/intel.nix
  ];

  # Need at least 6.9 to make suspend properly
  # Specifically this patch: https://github.com/torvalds/linux/commit/073237281a508ac80ec025872ad7de50cfb5a28a
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.9") (lib.mkDefault pkgs.linuxPackages_latest);

  # Intel NPU Driver
  # https://discourse.nixos.org/t/new-installation-on-asus-zenbook-ux5406-intel-vpu-firmware-error-2/58732/2
  hardware.firmware = lib.optionals (config.hardware.enableRedistributableFirmware) [
    (
      let
        model = "37xx";
        version = "0.0";

        firmware = pkgs.fetchurl {
          url = "https://github.com/intel/linux-npu-driver/raw/v1.13.0/firmware/bin/vpu_${model}_v${version}.bin";
          hash = "sha256-Mpoeq8HrwChjtHALsss/7QsFtDYAoFNsnhllU0xp3os=";
        };
      in
      pkgs.runCommand "intel-vpu-firmware-${model}-${version}" { } ''
        mkdir -p "$out/lib/firmware/intel/vpu"
        cp '${firmware}' "$out/lib/firmware/intel/vpu/vpu_${model}_v${version}.bin"
      ''
    )
  ];

  warnings = lib.mkIf (!config.hardware.enableRedistributableFirmware) [
    ''For Intel NPU support, set the option: hardware.enableRedistributableFirmware = true;''
 ];

}
