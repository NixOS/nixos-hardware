{
  config,
  lib,
  ...
}:

let
  inherit (lib)
    mkDefault
    mkIf
    mkMerge
    ;

  cfg = config.hardware.asus.flow.gv302x;
in
{

  imports = [
    ../../../common/cpu/amd
    # Better power-savings from AMD PState:
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  config = mkMerge [
    {
      # Configure basic system settings:
      boot = {
        kernelModules = [ "kvm-amd" ];
        kernelParams = [
          "mem_sleep_default=deep"
          "pcie_aspm.policy=powersupersave"
        ];
      };

      services = {
        asusd = {
          enable = mkDefault true;
          enableUserService = mkDefault true;
        };

        supergfxd.enable = mkDefault true;
      };

      #flow devices are 2 in 1 laptops
      hardware.sensor.iio.enable = mkDefault true;
    }

    (mkIf (!cfg.keyboard.autosuspend.enable) {
      services.udev.extraRules = ''
        # Disable power auto-suspend for the ASUS N-KEY device, i.e. USB Keyboard.
        # Otherwise on certain kernel-versions, it will tend to take 1-2 key-presses to wake-up after the device suspends.
        ACTION=="add", SUBSYSTEM=="usb", TEST=="power/autosuspend", ATTR{idVendor}=="0b05", ATTR{idProduct}=="19b6", ATTR{power/autosuspend}="-1"
      '';
    })
  ];
}
