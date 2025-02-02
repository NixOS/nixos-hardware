{ lib
, pkgs
, config
, ...
}:
let
  cfg = config.hardware.rockchip;
in {
  imports = [
    rk3399/disko.nix
  ];

  config = lib.mkIf cfg.enable {
    disko = {
      imageBuilder = {
        extraRootModules = [ "bcachefs" ];
        extraPostVM = cfg.diskoExtraPostVM;
      };
      memSize = lib.mkDefault 4096; # Default 1024 MB will throw "Cannot allocate memory" error
      devices.disk.main = {
        type = "disk";
        imageSize = lib.mkDefault "2G";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              # Firmware backoff
              start = "16M";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0022" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "bcachefs";
                mountpoint = "/";
                extraArgs = [
                  "--metadata_checksum=xxhash"
                  "--data_checksum=xxhash"
                  "--compression=zstd"
                  "--background_compression=zstd"
                  "--str_hash=siphash"
                  "--wide_macs"
                  "--encrypted"
                  "--no_passphrase"
                  "--discard"
                ];
              };
            };
          };
        };
      };
    };
  };
}
