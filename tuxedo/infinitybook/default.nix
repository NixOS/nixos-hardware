{ lib, options, ... }:
{
  imports = [
    ../../common/pc/laptop
    ../../common/pc/ssd
  ];

  # Enable TUXEDO's kernel drivers if they are available
  hardware = lib.optionalAttrs (options.hardware ? tuxedo-drivers) {
    tuxedo-drivers.enable = lib.mkDefault true;
  };
}
