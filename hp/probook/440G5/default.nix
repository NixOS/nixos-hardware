{ config, lib, ... }:

{
  # https://www.intel.com/content/www/us/en/products/sku/124967/intel-core-i58250u-processor-6m-cache-up-to-3-40-ghz/specifications.html
  # this one works: https://nixos.wiki/wiki/Accelerated_Video_Playback
  imports = [
    ../../../common/cpu/intel/kaby-lake
    ../../../common/pc
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  config = {
    services.thermald.enable = lib.mkDefault true;
  };
}
