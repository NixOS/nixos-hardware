{ lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  boot = {
    kernelPackages = lib.mkDefault (pkgs.linuxPackagesFor pkgs.linux_rpi5);
    initrd.availableKernelModules = [
      "nvme"
      "usbhid"
      "usb_storage"
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
}
