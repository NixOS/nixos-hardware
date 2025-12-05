{ config, lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  options = {
    hardware.broadcom.wifi.enableLegacyDriverWithKnownVulnerabilities = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable the legacy Broadcom WiFi driver (wl) with known security vulnerabilities.

        This driver is vulnerable to heap buffer overflows:
        - CVE-2019-9501 (https://github.com/advisories/GHSA-vjw8-c937-7hwp)
        - CVE-2019-9502 (https://github.com/advisories/GHSA-4rfg-8q34-prmp)

        Attackers within WiFi range can exploit this vulnerability by sending crafted
        WiFi packets, even without being connected to the same network. Simply having
        WiFi enabled makes the system vulnerable to arbitrary code execution or denial-of-service.
        Only enable if no alternative WiFi solution is available.
      '';
    };
  };

  config = {
    boot.kernelModules = [
      "kvm-intel"
    ]
    ++ lib.optionals config.hardware.broadcom.wifi.enableLegacyDriverWithKnownVulnerabilities [ "wl" ];
    boot.extraModulePackages =
      lib.mkIf config.hardware.broadcom.wifi.enableLegacyDriverWithKnownVulnerabilities
        [
          (config.boot.kernelPackages.broadcom_sta.overrideAttrs (oldAttrs: {
            meta = oldAttrs.meta // {
              knownVulnerabilities = [ ];
            };
          }))
        ];

    services = {
      fwupd.enable = lib.mkDefault true;
      thermald.enable = lib.mkDefault true;
    };
  };
}
