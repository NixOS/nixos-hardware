{ modulesPath, ... }:

{
  imports = [
    "${modulesPath}/profiles/installation-device.nix"
    ./sd-image.nix
  ];

  # The installation media is also the installation target.
  installer.cloneConfig = false;
}
