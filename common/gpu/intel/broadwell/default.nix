{ lib, pkgs, ... }:

{
  imports = [ ../. ];

  nixpkgs.overlays = [
    (
      self: super:
      if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11") then
        { vaapiIntel = super.vaapiIntel.override { enableHybridCodec = true; }; }
      else
        { intel-vaapi-driver = super.intel-vaapi-driver.override { enableHybridCodec = true; }; }
    )
  ];
}
