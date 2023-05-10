{ lib, config, ... }:

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  services = {
    asusd.enable = lib.mkDefault true;

    # fixes mic mute button
    udev.extraHwdb = ''
      evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
       KEYBOARD_KEY_ff31007c=f20
    '';
  };

  boot = {
    kernelParams = [ "pcie_aspm.policy=powersupersave" ];
  };

  assertions = [
    {
      assertion = (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.2");
      message = "The ga402 requires kernel version >=6.2 to ensure that fans are correctly managed. Please upgrade nixpkgs for this system.";
    }
  ];
}
