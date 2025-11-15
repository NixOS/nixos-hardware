{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    versionAtLeast
    ;

  cfg = config.hardware.asus.flow.gv301x;
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

  options.hardware.asus.flow.gv301x = {
    # Kernels earlier than 6.9 (possibly even earlier) tend to take 1-2 key-presses
    # to wake-up the internal keyboard after the device is suspended.
    # Therefore, this option disables auto-suspend for the keyboard by default, but
    # enables it for kernel 6.9.x onwards.
    #
    # Note: the device name is "ASUS N-KEY Device".
    keyboard.autosuspend.enable =
      (mkEnableOption "Enable auto-suspend on the internal USB keyboard (ASUS N-KEY Device) on Flow GV301X")
      // {
        default = versionAtLeast config.boot.kernelPackages.kernel.version "6.9";
        defaultText = lib.literalExpression "lib.versionAtLeast config.boot.kernelPackages.kernel.version \"6.9\"";
      };
  };

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
