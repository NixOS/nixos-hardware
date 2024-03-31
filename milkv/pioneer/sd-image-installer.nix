{ modulesPath, ... }:

{
  imports = [
    "${modulesPath}/profiles/installation-device.nix"
    ./sd-image.nix
  ];

  # the installation media is also the installation target,
  # so we don't want to provide the installation configuration.nix.
  installer.cloneConfig = false;
}
