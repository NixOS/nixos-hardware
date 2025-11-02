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
    keyd.enable = lib.mkDefault true;
  };
  
  services.keyd = {
  keyboards = {
    # The name is just the name of the configuration file, it does not really matter
    default = {
      ids = [ "*" ]; # what goes into the [id] section, here we select all keyboards
      # Everything but the ID section:
      settings = {
        # The main layer, if you choose to declare it in Nix
        main = {
	  f1 = "A-left";
	  f2 = "A-right";
          f3 = "refresh";
          f4 = "A-f10";
          f5 = "A-tab";
          f6 = "brightnessdown";
          f7 = "brightnessup";
          f8 = "mute";
          f9 = "volumedown";
          f10 = "volumeup";
          f13 = "coffee";
        };
        control = {
        f5 = "sysrq";
        };
	alt = {
	leftmeta = "capslock";
	left = "home";
	right = "end";
	up = "pageup";
	down = "pagedown";	
	};
      };
      extraConfig = ''
        # put here any extra-config, e.g. you can copy/paste here directly a configuration, just remove the ids part
      '';
    };
  };
};

  # Optional, but makes sure that when you type the make palm rejection work with keyd
  # https://github.com/rvaiya/keyd/issues/723
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';

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

