# To build, use:
# nix-build "<nixpkgs/nixos>" -I nixos-config=starfive/visionfive/v1/sd-image-installer.nix -A config.system.build.sdImage
{ modulesPath, ... }:

{
  imports = [
    "${modulesPath}/profiles/installation-device.nix"
    ./sd-image.nix
  ];

  # The installation media is also the installation target,
  # so we don't want to provide the installation configuration.nix.
  installer.cloneConfig = false;
}
