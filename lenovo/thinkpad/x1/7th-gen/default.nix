{ lib, ... }:
{
  imports = [
    ../.
    ../../../../common/pc/ssd
  ];

  services.throttled.enable = lib.mkDefault true;
}
