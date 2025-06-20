{ lib, ... }:
{
  imports = [
    ../.
  ];

  # without throttled, our CPU (i5-1235u) did not boost beyond 1300MHz
  services.throttled.enable = lib.mkDefault true;
}
