{ pkgs, lib, ... }: {
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];

  # https://gitlab.freedesktop.org/drm/amd/-/issues/2812#note_2190544 
  boot.kernelParams = ["mem_sleep_default=deep" "rtc_cmos.use_acpi_alarm=1"];

  # suspend needs kernel 6.7 or later
  boot.kernelPackages =  lib.mkIf (lib.versionOlder pkgs.linux.version "6.7") pkgs.linuxPackages_latest;

  # https://gitlab.freedesktop.org/drm/amd/-/issues/2812#note_2190544 
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
  boot.initrd.prepend = lib.mkOrder 0 [ "${pkgs.fetchurl {
    url = "https://gitlab.freedesktop.org/drm/amd/uploads/9fe228c7aa403b78c61fb1e29b3b35e3/slim7-ssdt";
    sha256 = "sha256-Ef4QTxdjt33OJEPLAPEChvvSIXx3Wd/10RGvLfG5JUs=";
    name = "slim7-ssdt";
  }}" ];
}

