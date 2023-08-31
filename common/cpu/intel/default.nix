{lib, ...}:

{
  imports = [
    ./cpu-only.nix
    ../../gpu/intel
  ];

  services.hardware.openrgb.motherboard = lib.mkDefault "intel";
}
