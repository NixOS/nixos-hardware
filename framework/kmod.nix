{ config, lib, pkgs, ... }:
let
  kernel_version_compatible = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.10";
in {
  options.hardware.framework.enableKmod = (lib.mkEnableOption
    "Enable the community created Framework kernel module that allows interacting with the embedded controller from sysfs."
  ) // {
    # enable by default on NixOS >= 24.05 and kernel >= 6.10
    default = lib.and
      (lib.versionAtLeast (lib.versions.majorMinor lib.version) "24.05")
      kernel_version_compatible;
    defaultText = "enabled by default on NixOS >= 24.05 and kernel >= 6.10";
  };


  config.boot = lib.mkIf config.hardware.framework.enableKmod {
    extraModulePackages = with config.boot.kernelPackages; [
      framework-laptop-kmod
    ];

    # https://github.com/DHowett/framework-laptop-kmod?tab=readme-ov-file#usage
    kernelModules = [ "cros_ec" "cros_ec_lpcs" ];

    # add required patch if enabled on kernel <6.10
    kernelPatches = lib.mkIf (!kernel_version_compatible) [
      rec {
        name = "platform/chrome: cros_ec_lpc: add support for AMD Framework Laptops";
        msgid = "20240403004713.130365-1-dustin@howett.net";
        version = "3";
        hash = "sha256-aQSyys8CMzlj9EdNhg8vtp76fg1qEwUVeJL0E+8w5HU=";
        patch = pkgs.runCommandLocal "patch-${msgid}" {
          nativeBuildInputs = with pkgs; [ b4 git cacert ];
          SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

          outputHash = hash;
        } ''
          export HOME="$TMP"
          PYTHONHASHSEED=0 ${pkgs.b4}/bin/b4 -n am -C -T -v ${version} -o- "${msgid}" > "$out"
        '';
      }
    ];
  };
}
