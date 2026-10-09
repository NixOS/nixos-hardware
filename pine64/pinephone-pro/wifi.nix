{ config, lib, ... }:
let
  cfg = config.hardware.pinephone-pro;
in
{
  options.hardware.pinephone-pro = {
    wifi.workaround-sae = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        A bug in the brcmfmac module causes it to attempt to offload SAE.
        This will cause connection failures and the following error message

        brcmfmac: brcmf_set_channel: set chanspec 0x???? fail, reason -52

        Related: https://github.com/raspberrypi/linux/issues/6049  
      '';
    };
  };
  config = lib.mkIf cfg.wifi.workaround-sae {
    #Disable SAE and FWSUP
    #See: https://iwd.wiki.kernel.org/offloading
    boot.extraModprobeConfig = lib.mkDefault ''
      options brcmfmac feature_disable=0x82000
    '';
  };
}
