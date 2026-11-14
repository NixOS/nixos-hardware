# Adapted from nixpkgs' installer/sd-card/sd-image-raspberrypi.nix.
{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    # The generic installer utilities include EFI tools broken on 32-bit ARM.
    "${modulesPath}/profiles/minimal.nix"
    "${modulesPath}/installer/sd-card/sd-image.nix"
    ./default.nix
  ];

  # This image targets the Pi 1, whose vendor kernel lacks generic PCI drivers.
  hardware.enableAllHardware = lib.mkForce false;

  sdImage = {
    # The shared firmware installer also copies the device-tree overlays.
    firmwareSize = lib.mkDefault 128;
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };
}
