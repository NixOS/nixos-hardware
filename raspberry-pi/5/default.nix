{
  lib,
  pkgs,
  config,
  ...
}:

let
  linuxVariant = config.boot.kernelPackages.kernel.pname;
in
{
  imports = [ ../common/default.nix ];

  boot = {
    loader.grub.enable = lib.mkDefault false;
    loader.generic-extlinux-compatible.enable = lib.mkDefault true;
    kernelPackages = lib.mkDefault (
      pkgs.linuxPackagesFor (pkgs.callPackage ../common/kernel.nix { rpiVersion = 5; })
    );
    initrd.availableKernelModules = [
      "nvme"
      "pcie-brcmstb"
      "clk-rp1"
    ]
    # CONFIG_MISC_RP1 is named CONFIG_MFD_RP1 in RPi's fork.
    ++ lib.optional (linuxVariant == "linux") "rp1_pci"
    ++ lib.optional (linuxVariant == "linux-rpi") "rp1"
    # CONFIG_PINCTRL_RP1 is not a tristate in RPi's fork.
    ++ lib.optional (linuxVariant == "linux") "pinctrl-rp1"
    ++ lib.optional config.boot.initrd.network.enable "macb";
  };

  hardware.deviceTree.filter = lib.mkDefault "bcm2712*-rpi-*.dtb";

  # Needed for Xorg to start (https://github.com/raspberrypi-ui/gldriver-test/blob/master/usr/lib/systemd/scripts/rp1_test.sh)
  # This won't work for displays connected to the RP1 (DPI/composite/MIPI DSI), since I don't have one to test.
  services.xserver.extraConfig = ''
    Section "OutputClass"
      Identifier "vc4"
      MatchDriver "vc4"
      Driver "modesetting"
      Option "PrimaryGPU" "true"
    EndSection
  '';

  assertions = [
    {
      assertion = (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.1.54");
      message = "The Raspberry Pi 5 requires a newer kernel version (>=6.1.54). Please upgrade nixpkgs for this system.";
    }
  ];
}
