{ pkgs, ... }:
{
  imports = [
    ../../../common/cpu/amd
    ../../../common/gpu/amd
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ./TLP.nix
  ];

  hardware.firmware = [ pkgs.sof-firmware ];

  boot = {
    blacklistedKernelModules = [
      "snd_acp_pci"
      "snd_pci_acp3x"
      "snd_pci_acp5x"
      "snd_pci_acp6x"
    ];

    extraModprobeConfig = ''
      options snd-hda-intel dmic_detect=0
    '';
  };
}
