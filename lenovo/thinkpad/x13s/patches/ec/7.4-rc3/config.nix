{ lib, ... }:
{
  structuredExtraConfig = with lib.kernel; {
    EC_LENOVO_THINKPAD_X13S = module;
  };
}
