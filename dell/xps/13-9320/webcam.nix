{ config, pkgs, ... }:

{
  hardware.firmware = let
    ivsc-firmware = with pkgs; stdenv.mkDerivation rec {
      pname = "ivsc-firmware";
      version = "10c214fea5560060d387fbd2fb8a1af329cb6232";

      src = pkgs.fetchFromGitHub {
        owner = "intel";
        repo = "ivsc-firmware";
        rev = version;
        sha256 = "sha256-kEoA0yeGXuuB+jlMIhNm+SBljH+Ru7zt3PzGb+EPBPw=";

      };

      installPhase = ''
        mkdir -p $out/lib/firmware/vsc/soc_a1_prod

        cp firmware/ivsc_pkg_ovti01a0_0.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_pkg_ovti01a0_0_a1_prod.bin
        cp firmware/ivsc_skucfg_ovti01a0_0_1.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_skucfg_ovti01a0_0_1_a1_prod.bin
        cp firmware/ivsc_fw.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_fw_a1_prod.bin
      '';
    };
  in [
    ivsc-firmware
  ];
  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };
}
