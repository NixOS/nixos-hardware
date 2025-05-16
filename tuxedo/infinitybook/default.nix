{ lib, options, ... }:
{
  imports = [
    ../../common/pc/laptop
    ../../common/pc/ssd
  ];

  hardware =
    lib.mkDefault {
      bluetooth.enable = true;
    }
    # Enable TUXEDO's kernel drivers if they are available
    // lib.optionalAttrs (options.hardware ? tuxedo-drivers) {
      tuxedo-drivers.enable = true;
    };
}
