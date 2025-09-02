{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ../../common/cpu/amd
    ../../common/cpu/amd/pstate.nix
    ../../common/cpu/amd/zenpower.nix
    ../../common/cpu/amd/raphael/igpu.nix
    ../../common/gpu/amd
    ../../common/gpu/nvidia
    ../../common/gpu/nvidia/ada-lovelace
    ../../common/gpu/nvidia/prime.nix
    ../../common/hidpi.nix
    ../../common/pc/laptop
    ../../common/pc/ssd
  ];

  # Resolve the issue of sleep mode being awakened by GPIO 6.
  # https://nova.gal/blog/%E6%9C%BA%E6%A2%B0%E9%9D%A9%E5%91%BD%E7%BF%BC%E9%BE%99-15Pro-%E8%BF%81%E7%A7%BB-Linux-%E9%81%87%E5%88%B0%E7%9A%84%E4%B8%80%E4%BA%9B%E9%97%AE%E9%A2%98#%E6%97%A0%E6%B3%95%E4%BC%91%E7%9C%A0
  # https://lore.kernel.org/all/20221012221028.4817-1-mario.limonciello@amd.com/T/
  boot.kernelParams = [ "gpiolib_acpi.ignore_interrupt=AMDI0030:00@6" ];

  hardware.nvidia = {
    primeBatterySaverSpecialisation = lib.mkDefault true;
    modesetting.enable = lib.mkDefault true;
    prime = {
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
