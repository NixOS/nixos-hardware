{lib, config, ...}:
let
  nividiaPackage = config.hardware.nvidia.package;
in
{
  imports = [ ../. ];

  # enable the opensorce drivers if the package supports it
  hardware.nvidia.open = lib.mkDefault (nividiaPackage ? open && nividiaPackage ? firmware);
}
