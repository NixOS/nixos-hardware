{
  lib,
  ...
}:
{
  # Backward-compat for 24.05, can be removed after we drop 24.05 support
  imports = lib.optionals (lib.versionOlder lib.version "24.11pre") [
    (lib.mkAliasOptionModule [ "hardware" "graphics" "enable" ] [ "hardware" "opengl" "enable" ])
    (lib.mkAliasOptionModule [ "hardware" "graphics" "extraPackages" ] [ "hardware" "opengl" "extraPackages" ])
    (lib.mkAliasOptionModule [ "hardware" "graphics" "extraPackages32" ] [ "hardware" "opengl" "extraPackages32" ])
    (lib.mkAliasOptionModule [ "hardware" "graphics" "enable32Bit" ] [ "hardware" "opengl" "driSupport32Bit" ])
    (lib.mkAliasOptionModule [ "hardware" "graphics" "package" ] [ "hardware" "opengl" "package" ])
    (lib.mkAliasOptionModule [ "hardware" "graphics" "package32" ] [ "hardware" "opengl" "package32" ])
  ];
}
