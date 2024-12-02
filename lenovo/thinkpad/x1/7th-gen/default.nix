{ lib, ... }:
{
  imports = [
    ../.
    ../../../../common/pc/laptop/ssd
  ];

  services.throttled.enable = lib.mkDefault true;
}
