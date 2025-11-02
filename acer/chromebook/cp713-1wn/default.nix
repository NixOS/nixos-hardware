{ lib, pkgs, ... }:

let
  alsa-ucm-conf-cros = pkgs.callPackage ./alsa-ucm-conf-cros.nix { };
in {
  imports = [
  ../../../common/cpu/intel/kaby-lake
  ../../../common/pc/laptop
  ../../../common/hidpi.nix 
  ];

  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=4
    options snd-soc-avs ignore_fw_version=1
    options snd-soc-avs obsolete_card_names=1
  '';

  boot.initrd.systemd.tpm2.enable = lib.mkDefault false;
  boot.kernelParams = [ "iomem=relaxed" ];
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.sensor.iio.enable = lib.mkDefault true;
  services = {
    libinput.enable = lib.mkDefault true;
  };

  security.tpm2.enable = lib.mkDefault false;

  environment.sessionVariables.ALSA_CONFIG_UCM2 = lib.mkDefault "${alsa-ucm-conf-cros}/share/alsa/ucm2";
  
  services.pipewire.wireplumber.extraConfig."51-increase-headroom" = {
  "monitor.alsa.rules" = [
    {
      matches = [
        {
          "node.name" = "~alsa_output.*";
        }
      ];
      actions = {
        "update-props" = {
          "api.alsa.headroom" = 4096;
        };
      };
    }
  ];
};
}

