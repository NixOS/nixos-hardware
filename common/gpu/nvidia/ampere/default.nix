{lib, config, ...}:
let
  nvidiaPackage = config.hardware.nvidia.package;
in
{
  imports = [ ../. ];

  # enable the open source drivers if the package supports it
  hardware.nvidia.open = lib.mkOverride 990 (nvidiaPackage ? open && nvidiaPackage ? firmware);
}
