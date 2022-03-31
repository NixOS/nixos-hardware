{ lib, ... }:

{
  services.fstrim.enable = lib.mkDefault true;
}
