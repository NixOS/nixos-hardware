{
  lib,
  pkgs,
  config,
  ...
}:
{
  boot = {
    kernelPackages = lib.mkDefault (
      pkgs.linuxPackagesFor (
        pkgs.callPackage ../common/kernel.nix {
          rpiVersion = 5;
        }
      )
    );
    initrd.availableKernelModules = [
      "nvme"
      "usbhid"
      "usb-storage"
    ];
  };

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
